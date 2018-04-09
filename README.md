祝日判定を行うプラグインです
====

MTテンプレートで祝日判定を行います。
カレンダーIDを変更する事で日本以外の祝日も対応できるはずですが試していません。

## 機能

* 追加されるタグ   
  * ブロックタグ   
    * <mt:JPHoliday month="yyyymm"> 祝日判定をする箇所を括ります   
    * <mt:IfJPHoliday date="yyyy-mm-dd"> 祝日判定を行います。dateを省略するとCalendarDateが利用されます  
  * ファンクションタグ   
    * <$mt:JPHolidayName date="yyyy-mm-dd"$> 祝日名を出力します。dateを省略するとCalendarDateが利用されます   
    * <$mt:JPHolidayRawJSON$> Google APIから取得した一ヶ月分の祝日情報をJSONで出力します   

4月の祝日を取得し判定する例は以下になります。
```
<mt:JPHoliday month="201804">
<mt:IfJPHoliday date="2018-04-29">
今日は<$mt:JPHolidayName date="2018-04-29"$>の日です
</mt:IfJPHoliday>
</mt:JPHoliday>
```

MTCalendarと組合わせて利用する例
```
<mt:JPHoliday month="201804">
<mt:Calendar month="201804">

  <mt:CalendarWeekHeader><tr></mt:CalendarWeekHeader>
  <mt:CalendarIfBlank>
    <td>&nbsp;</td>
  <mt:Else>
    <mt:IfJPHoliday>
      <mt:SetVarBlock name="class"> class="holiday"</mt:SetVarBlock>
      <mt:SetVarBlock name="title"><$mt:CalendarDate format="%Y年%m月%d日"$>(<$mt:JPHolidayName$>)</mt:SetVarBlock>
    <mt:Else>
      <mt:SetVarBlock name="title"><$mt:CalendarDate format="%Y年%m月%d日"$></mt:SetVarBlock>
      <mt:If tag="CalendarDate" format="%w" eq="0">
        <mt:SetVarblock name="class"> class="sunday"</mt:SetVarBlock>
      <mt:ElseIf tag="CalendarDate" format="%w" eq="6">
        <mt:SetVarBlock name="class"> class="saturday"</mt:SetVarBlock>
      <mt:Else>
        <$mt:SetVar name="class" value=""$>
      </mt:If>
    </mt:IfJPHoliday>
    <td title="<$mt:GetVar name="title"$>"<$mt:GetVar name="class"$>>
    <mt:CalendarIfEntries>
      <a href="<mt:Entries lastn="1"><$mt:EntryPermalink$></mt:Entries>"><$mt:CalendarDay$></a>
    </mt:CalendarIfEntries>
    <mt:CalendarIfNoEntries>
      <$mt:CalendarDay$>
    </mt:CalendarIfNoEntries>
    </td>
  </mt:CalendarIfBlank>
  <mt:CalendarWeekFooter></tr></mt:CalendarWeekFooter>

</mt:Calendar month="2018-04">
</mtJPHoliday month="2018-04">
```

Google Calendar APIのJSONを直接参照する場合
```
<mt:JPHoliday month="201804">
<$mt:JPHolidayRawJSON$>
</mt:JPHoliday>

```

ifJPHoliday及びJPHolidayNameは引数のmonthが必須です。   
フォーマット：%Y-%m-%d   
MTCalendarタグ内で利用する場合は引数は必要ありません。   

## 動作環境

MT6で動作確認をしていますが、MT5,MT7でも利用できると思います。

## 設定

GoogleアカウントでカレンダーAPIのaccesskeyを取得し、プラグイン設定に保存してください。
CalendarIDの設定は日本の祝日の場合は変更しないで下さい。日本以外の祝日に適用したい場合は変更して下さい。(動作保証しません）

## 注意

GoogleのAPIは100万クエリ/月間まで無料のようです。   
プラグインはβ版です。動作保証は致しません。十分検証の上ご利用ください。   

## Licence

[ライセンス](https://github.com/onagatani/mt-plugin-JPHoliday/blob/master/LICENSE)

## Author

[COLSIS inc.](https://colsis.jp)

