package MT::Plugin::JPHoliday;
use strict;
use warnings;
use base qw( MT::Plugin );
use JPHoliday::Tags;

our $PLUGIN_NAME = 'JPHoliday';
our $VERSION = '0.1';

my $plugin = __PACKAGE__->new({
    name           => $PLUGIN_NAME,
    version        => $VERSION,
    key            => $PLUGIN_NAME,
    id             => $PLUGIN_NAME,
    author_name    => 'COLSIS Inc.',
    author_link    => 'https://colsis.jp/',
    description    => '<__trans phrase="JPHoliday.">',
    plugin_link    => 'https://colsis.jp',
    registry       => {
        l10n_lexicon => {
            ja => {
                'JPHoliday.' => '祝日を判定します',
                'couldn\'t get contents : [_1]' => '[_1]のコンテンツを取得できませんでした',
            },
        },
        tags => +{
            block => +{
                'JPHoliday'    => 'JPHoliday::Tags::jp_holiday',
                'IfJPHoliday?' => 'JPHoliday::Tags::if_jp_holiday',
            },
            function => +{
                JPHolidayName => 'JPHoliday::Tags::jp_holiday_name',
                JPHolidayRawJSON => 'JPHoliday::Tags::jp_holiday_raw_json',
            },
        },
    },
    system_config_template => \&_system_config,
    settings => MT::PluginSettings->new([
        ['apikey' ,{ Default => undef , Scope => 'system' }],
        ['calendar_id' ,{ Default => 'japanese__ja@holiday.calendar.google.com' , Scope => 'system' }],
    ]),
});

MT->add_plugin( $plugin );

sub _system_config {
    return <<'__HTML__';
<mtapp:setting
    id="apikey"
    label="<__trans phrase="Google API KEY">">
<input type="text" name="apikey" value="<$mt:getvar name="apikey" escape="html"$>" />
</mtapp:setting>
<mtapp:setting
    id="calendar_id"
    label="<__trans phrase="Google Calender ID">">
<input type="text" name="calendar_id" value="<$mt:getvar name="calendar_id" escape="html"$>" />
</mtapp:setting>
__HTML__
}

1;
__END__
