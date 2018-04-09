package JPHoliday::Tags;
use strict;
use warnings;
use utf8;
use JPHoliday::UA;
use URI;
use JSON qw/decode_json to_json/;
use Encode;
use constant ENDPOINT => 'https://www.googleapis.com/calendar/v3/calendars/%s/events';

sub jp_holiday {
    my ($ctx, $args, $cond) = @_;
    return if $ctx->{__stash}{holiday_name};

    my $blog = $ctx->{__stash}{blog} or return;

    my $plugin = MT->component('JPHoliday');

    my $config = $plugin->get_config_hash('system');

    my $year_month = $args->{month} or return;
    my ( $year, $month ) = unpack 'A4A2', $year_month;

    my $start_date = sprintf'%s-%02d-01T00:00:00Z', $year, $month;

    $month == 12 ? $year++ : $month++;

    my $end_date = sprintf'%s-%02d-01T00:00:00Z', $year, $month;

    my $api_url = sprintf ENDPOINT(), $config->{calendar_id};

    my $uri = URI->new($api_url);
    $uri->query_form(
        key => $config->{apikey},
        singleEvents => 'true',
        format => 'json',
        timeMin => $start_date,
        timeMax => $end_date,
    );

    my $ua = JPHoliday::UA->new;

    my $res = $ua->get($uri->as_string) or
        return MT->log(+{
            class   => 'blog',
            blog_id => $blog->id,
            message => $plugin->translate("couldn't get contents : [_1]", $uri->as_string),
            level   => MT::Log::ERROR(),
        });

    my $data = decode_json($res);
    
    my $holiday;

    for my $item (@{$data->{items}}) {
        $holiday->{ $item->{start}->{date} } = $item->{summary};
    }
    local $ctx->{__stash}{holiday_name} = $holiday;
    local $ctx->{__stash}{holiday_raw_json} = to_json($data);
    return $ctx->slurp($args, $cond);
}

sub if_jp_holiday {
    my ($ctx, $args) = @_;

    my $holiday = $ctx->stash('holiday_name') or return;
    my $date = $args->{date} ? $args->{date} : $ctx->tag('CalendarDate', { format => '%Y-%m-%d' });

    return $holiday->{$date} ? 1 : 0;
}

sub jp_holiday_name {
    my ($ctx, $args) = @_;

    my $holiday = $ctx->stash('holiday_name') or return;
    my $date = $args->{date} ? $args->{date} : $ctx->tag('CalendarDate', { format => '%Y-%m-%d' });

    return $holiday->{$date};
}

sub jp_holiday_raw_json {
    my ($ctx, $args) = @_;

    my $json = $ctx->stash('holiday_raw_json') or return;

    return $json;
}


1;

