//+------------------------------------------------------------------+
//|                                                 OK Converter.mq5 |
//|                                  Copyright 2023, Maxim Savochkin |
//|                 https://www.mql5.com/en/users/m_savochkin99/news |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Maxim Savochkin"
#property link      "https://www.mql5.com/en/users/m_savochkin99/news"
#include  <OK Color Space.mqh>
//--- display scaling
double  scale_factor = double(TerminalInfoInteger(TERMINAL_SCREEN_DPI)) / 96.0;
#define SCALE_ROUND(a) (int(MathRound(double(a)*scale_factor)))
//--- chart properties
bool  chart_prop_show;
bool  chart_prop_context_menu;
bool  chart_prop_mouse_scroll;
bool  chart_prop_keyboard_control;
color chart_prop_background_color;
int   chart_width, chart_height;
//--- parameter indents
int parameter_width = SCALE_ROUND(64);
int parameter_height = SCALE_ROUND(36);
int x_indent_0 = SCALE_ROUND(20);
int x_indent_1 = SCALE_ROUND(120);
int x_indent_2 = x_indent_1 + parameter_width;
int x_indent_3 = x_indent_2 + parameter_width;
int y_indent_1 = SCALE_ROUND(36);
int y_indent_2 = y_indent_1 + parameter_height + SCALE_ROUND(4);
int y_indent_3 = y_indent_2 + parameter_height + SCALE_ROUND(4);
int fg_indent = SCALE_ROUND(24);
//--- colors
color  bg_clr = C'17,23,26';
RGB    bg_rgb;
OKhsl  bg_hsl;
OKhsv  bg_hsv;
color  fg_clr = clrPaleGreen;
RGB    fg_rgb;
OKhsl  fg_hsl;
OKhsv  fg_hsv;
color  bg_txt_clr;
color  fg_txt_clr;
//--- selected parameter info
string selected_parameter;
bool   selected_parameter_bg;
string selected_parameter_value;
bool   reset_parameter_value;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
//--- initialize colors
 ColorToRGB(bg_clr, bg_rgb);
 ColorToOKhsl(bg_clr, bg_hsl.h, bg_hsl.s, bg_hsl.l);
 ColorToOKhsv(bg_clr, bg_hsv.h, bg_hsv.s, bg_hsv.v);
 ColorToRGB(fg_clr, fg_rgb);
 ColorToOKhsl(fg_clr, fg_hsl.h, fg_hsl.s, fg_hsl.l);
 ColorToOKhsv(fg_clr, fg_hsv.h, fg_hsv.s, fg_hsv.v);
 if(GetRelativeLuminance(bg_clr) < 0.45) {
  bg_txt_clr = clrWhite; }
 else                                  {
  bg_txt_clr = clrBlack; }
 if(GetRelativeLuminance(fg_clr) < 0.45) {
  fg_txt_clr = clrWhite; }
 else                                  {
  fg_txt_clr = clrBlack; }
//--- save chart properties
 chart_prop_show = ChartGetInteger(0, CHART_SHOW);
 chart_prop_context_menu = ChartGetInteger(0, CHART_CONTEXT_MENU);
 chart_prop_mouse_scroll = ChartGetInteger(0, CHART_MOUSE_SCROLL);
 chart_prop_keyboard_control = ChartGetInteger(0, CHART_KEYBOARD_CONTROL);
 chart_prop_background_color = (color)ChartGetInteger(0, CHART_COLOR_BACKGROUND);
//--- set chart properties (and background color)
 ChartSetInteger(0, CHART_SHOW, false);
 ChartSetInteger(0, CHART_SHOW_DATE_SCALE, false);
 ChartSetInteger(0, CHART_SHOW_PRICE_SCALE, false);
 ChartSetInteger(0, CHART_CONTEXT_MENU, false);
 ChartSetInteger(0, CHART_MOUSE_SCROLL, false);
 ChartSetInteger(0, CHART_KEYBOARD_CONTROL, false);
 ChartSetInteger(0, CHART_COLOR_BACKGROUND, bg_clr);
//--- create interface
//--- background color
 chart_width = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0);
 chart_height = (int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS, 0);
 RectLabelCreate("BG", 0, 0, 0, chart_width, chart_height, bg_clr, 1);
 EditCreate("BG-RGB", 0, x_indent_0, y_indent_1, SCALE_ROUND(100), y_indent_1, "RGB", ALIGN_LEFT, true, bg_txt_clr, bg_clr, 0);
 EditCreate("BG-OKhsl", 0, x_indent_0, y_indent_2, SCALE_ROUND(100), y_indent_1, "OKhsl", ALIGN_LEFT, true, bg_txt_clr, bg_clr, 0);
 EditCreate("BG-OKhsv", 0, x_indent_0, y_indent_3, SCALE_ROUND(100), y_indent_1, "OKhsv", ALIGN_LEFT, true, bg_txt_clr, bg_clr, 0);
 EditCreate("BG-RGB-R", 0, x_indent_1, y_indent_1, parameter_width, parameter_height, DoubleToString(bg_rgb.r, 0), ALIGN_CENTER, true, bg_clr, bg_txt_clr, 2);
 EditCreate("BG-RGB-G", 0, x_indent_2, y_indent_1, parameter_width, parameter_height, DoubleToString(bg_rgb.g, 0), ALIGN_CENTER, true, bg_txt_clr, bg_clr, 2);
 EditCreate("BG-RGB-B", 0, x_indent_3, y_indent_1, parameter_width, parameter_height, DoubleToString(bg_rgb.b, 0), ALIGN_CENTER, true, bg_txt_clr, bg_clr, 2);
 EditCreate("BG-OKhsl-h", 0, x_indent_1, y_indent_2, parameter_width, parameter_height, DoubleToString(bg_hsl.h, 0), ALIGN_CENTER, true, bg_txt_clr, bg_clr, 2);
 EditCreate("BG-OKhsl-s", 0, x_indent_2, y_indent_2, parameter_width, parameter_height, DoubleToString(bg_hsl.s, 0), ALIGN_CENTER, true, bg_txt_clr, bg_clr, 2);
 EditCreate("BG-OKhsl-l", 0, x_indent_3, y_indent_2, parameter_width, parameter_height, DoubleToString(bg_hsl.l, 0), ALIGN_CENTER, true, bg_txt_clr, bg_clr, 2);
 EditCreate("BG-OKhsv-h", 0, x_indent_1, y_indent_3, parameter_width, parameter_height, DoubleToString(bg_hsv.h, 0), ALIGN_CENTER, true, bg_txt_clr, bg_clr, 2);
 EditCreate("BG-OKhsv-s", 0, x_indent_2, y_indent_3, parameter_width, parameter_height, DoubleToString(bg_hsv.s, 0), ALIGN_CENTER, true, bg_txt_clr, bg_clr, 2);
 EditCreate("BG-OKhsv-v", 0, x_indent_3, y_indent_3, parameter_width, parameter_height, DoubleToString(bg_hsv.v, 0), ALIGN_CENTER, true, bg_txt_clr, bg_clr, 2);
//--- foreground color
 int width = (int)MathRound(double(chart_width) / 2.0) - fg_indent;
 int height = chart_height - SCALE_ROUND(48);
 int x = (int)MathRound(double(chart_width) / 2.0);
 int y = fg_indent;
 RectLabelCreate("FG", 0, x, y, width, height, fg_clr, 1);
 EditCreate("FG-RGB", 0, x + x_indent_0, y_indent_1, SCALE_ROUND(100), y_indent_1, "RGB", ALIGN_LEFT, true, fg_txt_clr, fg_clr, 0);
 EditCreate("FG-OKhsl", 0, x + x_indent_0, y_indent_2, SCALE_ROUND(100), y_indent_1, "OKhsl", ALIGN_LEFT, true, fg_txt_clr, fg_clr, 0);
 EditCreate("FG-OKhsv", 0, x + x_indent_0, y_indent_3, SCALE_ROUND(100), y_indent_1, "OKhsv", ALIGN_LEFT, true, fg_txt_clr, fg_clr, 0);
 EditCreate("FG-RGB-R", 0, x + x_indent_1, y_indent_1, parameter_width, parameter_height, DoubleToString(fg_rgb.r, 0), ALIGN_CENTER, true, fg_txt_clr, fg_clr, 2);
 EditCreate("FG-RGB-G", 0, x + x_indent_2, y_indent_1, parameter_width, parameter_height, DoubleToString(fg_rgb.g, 0), ALIGN_CENTER, true, fg_txt_clr, fg_clr, 2);
 EditCreate("FG-RGB-B", 0, x + x_indent_3, y_indent_1, parameter_width, parameter_height, DoubleToString(fg_rgb.b, 0), ALIGN_CENTER, true, fg_txt_clr, fg_clr, 2);
 EditCreate("FG-OKhsl-h", 0, x + x_indent_1, y_indent_2, parameter_width, parameter_height, DoubleToString(fg_hsl.h, 0), ALIGN_CENTER, true, fg_txt_clr, fg_clr, 2);
 EditCreate("FG-OKhsl-s", 0, x + x_indent_2, y_indent_2, parameter_width, parameter_height, DoubleToString(fg_hsl.s, 0), ALIGN_CENTER, true, fg_txt_clr, fg_clr, 2);
 EditCreate("FG-OKhsl-l", 0, x + x_indent_3, y_indent_2, parameter_width, parameter_height, DoubleToString(fg_hsl.l, 0), ALIGN_CENTER, true, fg_txt_clr, fg_clr, 2);
 EditCreate("FG-OKhsv-h", 0, x + x_indent_1, y_indent_3, parameter_width, parameter_height, DoubleToString(fg_hsv.h, 0), ALIGN_CENTER, true, fg_txt_clr, fg_clr, 2);
 EditCreate("FG-OKhsv-s", 0, x + x_indent_2, y_indent_3, parameter_width, parameter_height, DoubleToString(fg_hsv.s, 0), ALIGN_CENTER, true, fg_txt_clr, fg_clr, 2);
 EditCreate("FG-OKhsv-v", 0, x + x_indent_3, y_indent_3, parameter_width, parameter_height, DoubleToString(fg_hsv.v, 0), ALIGN_CENTER, true, fg_txt_clr, fg_clr, 2);
//--- create rectangles to hide the text (when the width or height of the chart is too small)
 RectLabelCreate("BG-RIGHT", 0, x + width - 2, y, fg_indent + 20, height, bg_clr, 0);
 RectLabelCreate("BG-BOTTOM", 0, x, y + height - 2, width + fg_indent + 20, fg_indent + 20, bg_clr, 0);
//--- selected parameter info
 selected_parameter = "BG-RGB-R";
 selected_parameter_bg = true;
 selected_parameter_value = DoubleToString(bg_rgb.r, 0);
 reset_parameter_value = true;
 ChartRedraw();
//---
 return(INIT_SUCCEEDED); }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
//--- delete interface
 ObjectDelete(0, "BG");
 ObjectDelete(0, "BG-RIGHT");
 ObjectDelete(0, "BG-BOTTOM");
 ObjectDelete(0, "BG-RGB");
 ObjectDelete(0, "BG-OKhsl");
 ObjectDelete(0, "BG-OKhsv");
 ObjectDelete(0, "BG-RGB-R");
 ObjectDelete(0, "BG-RGB-G");
 ObjectDelete(0, "BG-RGB-B");
 ObjectDelete(0, "BG-OKhsl-h");
 ObjectDelete(0, "BG-OKhsl-s");
 ObjectDelete(0, "BG-OKhsl-l");
 ObjectDelete(0, "BG-OKhsv-h");
 ObjectDelete(0, "BG-OKhsv-s");
 ObjectDelete(0, "BG-OKhsv-v");
 ObjectDelete(0, "FG");
 ObjectDelete(0, "FG-RGB");
 ObjectDelete(0, "FG-OKhsl");
 ObjectDelete(0, "FG-OKhsv");
 ObjectDelete(0, "FG-RGB-R");
 ObjectDelete(0, "FG-RGB-G");
 ObjectDelete(0, "FG-RGB-B");
 ObjectDelete(0, "FG-OKhsl-h");
 ObjectDelete(0, "FG-OKhsl-s");
 ObjectDelete(0, "FG-OKhsl-l");
 ObjectDelete(0, "FG-OKhsv-h");
 ObjectDelete(0, "FG-OKhsv-s");
 ObjectDelete(0, "FG-OKhsv-v");
//--- set previous chart properties
 ChartSetInteger(0, CHART_SHOW, chart_prop_show);
 ChartSetInteger(0, CHART_SHOW_DATE_SCALE, chart_prop_show);
 ChartSetInteger(0, CHART_SHOW_PRICE_SCALE, chart_prop_show);
 ChartSetInteger(0, CHART_CONTEXT_MENU, chart_prop_context_menu);
 ChartSetInteger(0, CHART_MOUSE_SCROLL, chart_prop_mouse_scroll);
 ChartSetInteger(0, CHART_KEYBOARD_CONTROL, chart_prop_keyboard_control);
 ChartSetInteger(0, CHART_COLOR_BACKGROUND, chart_prop_background_color); }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam) {
 switch(id) {
 case CHARTEVENT_OBJECT_CLICK: {
  if(sparam == "BG-RGB-R" || sparam == "BG-RGB-G" || sparam == "BG-RGB-B" ||
     sparam == "BG-OKhsl-h" || sparam == "BG-OKhsl-s" || sparam == "BG-OKhsl-l" ||
     sparam == "BG-OKhsv-h" || sparam == "BG-OKhsv-s" || sparam == "BG-OKhsv-v") {
   ApplyParameterValue(selected_parameter);
   if(!selected_parameter_bg && selected_parameter != NULL) {
    ApplyColor(false); }
   SelectParameter(sparam, true);
   ChartRedraw(); }
  else if(sparam == "FG-RGB-R" || sparam == "FG-RGB-G" || sparam == "FG-RGB-B" ||
          sparam == "FG-OKhsl-h" || sparam == "FG-OKhsl-s" || sparam == "FG-OKhsl-l" ||
          sparam == "FG-OKhsv-h" || sparam == "FG-OKhsv-s" || sparam == "FG-OKhsv-v") {
   ApplyParameterValue(selected_parameter);
   if(selected_parameter_bg && selected_parameter != NULL) {
    ApplyColor(true); }
   SelectParameter(sparam, false);
   ChartRedraw(); }
  else if((sparam == "BG" || sparam == "BG-RIGHT" || sparam == "BG-BOTTOM" || sparam == "FG") && selected_parameter != NULL) {
   ApplyParameterValue(selected_parameter);
   DeselectParameter(selected_parameter, selected_parameter_bg);
   ApplyColor(selected_parameter_bg);
   ChartRedraw(); } } break;
 case CHARTEVENT_KEYDOWN: {
  if(selected_parameter == NULL) {
   break; }
  if(lparam == 8) { // Backspace
   selected_parameter_value = StringSubstr(selected_parameter_value, 0, StringLen(selected_parameter_value) - 1);
   if(selected_parameter_value == "") {
    selected_parameter_value = "0"; }
   ObjectSetString(0, selected_parameter, OBJPROP_TEXT, selected_parameter_value);
   SetParameterValue(selected_parameter, (float)StringToInteger(selected_parameter_value));
   reset_parameter_value = false;
   ChartRedraw();
   break; }
  if(lparam == 13) { // Enter
   ApplyParameterValue(selected_parameter);
   DeselectParameter(selected_parameter, selected_parameter_bg);
   ApplyColor(selected_parameter_bg);
   ChartRedraw();
   break; }
  if(lparam >= 48 && lparam <= 57) { // 0-9 digits
   int keyboard_digit = (int)lparam - 48;
   if(selected_parameter_value == "0" || reset_parameter_value) {
    selected_parameter_value = ""; }
   reset_parameter_value = false;
   string new_value = selected_parameter_value + IntegerToString(keyboard_digit);
   if(StringToInteger(new_value) == 0) {
    selected_parameter_value = "0"; }
   if(StringToInteger(new_value) <= GetMaxParameterValue(selected_parameter)) {
    selected_parameter_value = new_value; }
   ObjectSetString(0, selected_parameter, OBJPROP_TEXT, selected_parameter_value);
   SetParameterValue(selected_parameter, (float)StringToInteger(selected_parameter_value));
   ChartRedraw(); } } break;
 case CHARTEVENT_CHART_CHANGE: {
  Resize();
  ChartRedraw(); } break; } }
//+------------------------------------------------------------------+
//| GetMaxParameterValue                                             |
//+------------------------------------------------------------------+
int GetMaxParameterValue(
 string object_name
) {
 if(object_name == "BG-RGB-R" || object_name == "BG-RGB-G" || object_name == "BG-RGB-B" ||
    object_name == "FG-RGB-R" || object_name == "FG-RGB-G" || object_name == "FG-RGB-B") {
  return(255); }
 if(object_name == "BG-OKhsl-h" || object_name == "BG-OKhsv-h" ||
    object_name == "FG-OKhsl-h" || object_name == "FG-OKhsv-h") {
  return(360); }
 if(object_name == "BG-OKhsl-s" || object_name == "BG-OKhsv-s" || object_name == "BG-OKhsl-l" || object_name == "BG-OKhsv-v" ||
    object_name == "FG-OKhsl-s" || object_name == "FG-OKhsv-s" || object_name == "FG-OKhsl-l" || object_name == "FG-OKhsv-v") {
  return(100); }
 return(0); }
//+------------------------------------------------------------------+
//| GetParameterValue                                                |
//+------------------------------------------------------------------+
string GetParameterValue(
 string object_name
) {
 if(object_name == "BG-RGB-R")   return(DoubleToString(bg_rgb.r, 0));
 if(object_name == "BG-RGB-G")   return(DoubleToString(bg_rgb.g, 0));
 if(object_name == "BG-RGB-B")   return(DoubleToString(bg_rgb.b, 0));
 if(object_name == "BG-OKhsl-h") return(DoubleToString(bg_hsl.h, 0));
 if(object_name == "BG-OKhsl-s") return(DoubleToString(bg_hsl.s, 0));
 if(object_name == "BG-OKhsl-l") return(DoubleToString(bg_hsl.l, 0));
 if(object_name == "BG-OKhsv-h") return(DoubleToString(bg_hsv.h, 0));
 if(object_name == "BG-OKhsv-s") return(DoubleToString(bg_hsv.s, 0));
 if(object_name == "BG-OKhsv-v") return(DoubleToString(bg_hsv.v, 0));
 if(object_name == "FG-RGB-R")   return(DoubleToString(fg_rgb.r, 0));
 if(object_name == "FG-RGB-G")   return(DoubleToString(fg_rgb.g, 0));
 if(object_name == "FG-RGB-B")   return(DoubleToString(fg_rgb.b, 0));
 if(object_name == "FG-OKhsl-h") return(DoubleToString(fg_hsl.h, 0));
 if(object_name == "FG-OKhsl-s") return(DoubleToString(fg_hsl.s, 0));
 if(object_name == "FG-OKhsl-l") return(DoubleToString(fg_hsl.l, 0));
 if(object_name == "FG-OKhsv-h") return(DoubleToString(fg_hsv.h, 0));
 if(object_name == "FG-OKhsv-s") return(DoubleToString(fg_hsv.s, 0));
 if(object_name == "FG-OKhsv-v") return(DoubleToString(fg_hsv.v, 0));
 return(NULL); }
//+------------------------------------------------------------------+
//| SetParameterValue                                                |
//+------------------------------------------------------------------+
void SetParameterValue(
 string object_name,
 float  value
) {
 if(object_name == "BG-RGB-R")   {
  bg_rgb.r = value;
  return; }
 if(object_name == "BG-RGB-G")   {
  bg_rgb.g = value;
  return; }
 if(object_name == "BG-RGB-B")   {
  bg_rgb.b = value;
  return; }
 if(object_name == "BG-OKhsl-h") {
  bg_hsl.h = value;
  return; }
 if(object_name == "BG-OKhsl-s") {
  bg_hsl.s = value;
  return; }
 if(object_name == "BG-OKhsl-l") {
  bg_hsl.l = value;
  return; }
 if(object_name == "BG-OKhsv-h") {
  bg_hsv.h = value;
  return; }
 if(object_name == "BG-OKhsv-s") {
  bg_hsv.s = value;
  return; }
 if(object_name == "BG-OKhsv-v") {
  bg_hsv.v = value;
  return; }
 if(object_name == "FG-RGB-R")   {
  fg_rgb.r = value;
  return; }
 if(object_name == "FG-RGB-G")   {
  fg_rgb.g = value;
  return; }
 if(object_name == "FG-RGB-B")   {
  fg_rgb.b = value;
  return; }
 if(object_name == "FG-OKhsl-h") {
  fg_hsl.h = value;
  return; }
 if(object_name == "FG-OKhsl-s") {
  fg_hsl.s = value;
  return; }
 if(object_name == "FG-OKhsl-l") {
  fg_hsl.l = value;
  return; }
 if(object_name == "FG-OKhsv-h") {
  fg_hsv.h = value;
  return; }
 if(object_name == "FG-OKhsv-s") {
  fg_hsv.s = value;
  return; }
 if(object_name == "FG-OKhsv-v") {
  fg_hsv.v = value;
  return; } }
//+------------------------------------------------------------------+
//| ApplyParameterValue                                              |
//+------------------------------------------------------------------+
void ApplyParameterValue(
 string object_name
) {
 bool bg;
 if(object_name == "BG-RGB-R" || object_name == "BG-RGB-G" || object_name == "BG-RGB-B") {
  color clr = (color)(uchar(bg_rgb.b) << 16) | (uchar(bg_rgb.g) << 8) | uchar(bg_rgb.r);
  ColorToOKhsl(clr, bg_hsl.h, bg_hsl.s, bg_hsl.l);
  ColorToOKhsv(clr, bg_hsv.h, bg_hsv.s, bg_hsv.v);
  bg = true; }
 if(object_name == "BG-OKhsl-h" || object_name == "BG-OKhsl-s" || object_name == "BG-OKhsl-l") {
  color clr = OKhslToColor(bg_hsl.h, bg_hsl.s, bg_hsl.l);
  ColorToRGB(clr, bg_rgb);
  ColorToOKhsl(clr, bg_hsl.h, bg_hsl.s, bg_hsl.l);
  ColorToOKhsv(clr, bg_hsv.h, bg_hsv.s, bg_hsv.v);
  bg = true; }
 if(object_name == "BG-OKhsv-h" || object_name == "BG-OKhsv-s" || object_name == "BG-OKhsv-v") {
  color clr = OKhsvToColor(bg_hsv.h, bg_hsv.s, bg_hsv.v);
  ColorToRGB(clr, bg_rgb);
  ColorToOKhsl(clr, bg_hsl.h, bg_hsl.s, bg_hsl.l);
  ColorToOKhsv(clr, bg_hsv.h, bg_hsv.s, bg_hsv.v);
  bg = true; }
 if(object_name == "FG-RGB-R" || object_name == "FG-RGB-G" || object_name == "FG-RGB-B") {
  color clr = (color)(uchar(fg_rgb.b) << 16) | (uchar(fg_rgb.g) << 8) | uchar(fg_rgb.r);
  ColorToOKhsl(clr, fg_hsl.h, fg_hsl.s, fg_hsl.l);
  ColorToOKhsv(clr, fg_hsv.h, fg_hsv.s, fg_hsv.v);
  bg = false; }
 if(object_name == "FG-OKhsl-h" || object_name == "FG-OKhsl-s" || object_name == "FG-OKhsl-l") {
  color clr = OKhslToColor(fg_hsl.h, fg_hsl.s, fg_hsl.l);
  ColorToRGB(clr, fg_rgb);
  ColorToOKhsl(clr, fg_hsl.h, fg_hsl.s, fg_hsl.l);
  ColorToOKhsv(clr, fg_hsv.h, fg_hsv.s, fg_hsv.v);
  bg = false; }
 if(object_name == "FG-OKhsv-h" || object_name == "FG-OKhsv-s" || object_name == "FG-OKhsv-v") {
  color clr = OKhsvToColor(fg_hsv.h, fg_hsv.s, fg_hsv.v);
  ColorToRGB(clr, fg_rgb);
  ColorToOKhsl(clr, fg_hsl.h, fg_hsl.s, fg_hsl.l);
  ColorToOKhsv(clr, fg_hsv.h, fg_hsv.s, fg_hsv.v);
  bg = false; }
 if(bg) {
  ObjectSetString(0, "BG-RGB-R", OBJPROP_TEXT, DoubleToString(bg_rgb.r, 0));
  ObjectSetString(0, "BG-RGB-G", OBJPROP_TEXT, DoubleToString(bg_rgb.g, 0));
  ObjectSetString(0, "BG-RGB-B", OBJPROP_TEXT, DoubleToString(bg_rgb.b, 0));
  ObjectSetString(0, "BG-OKhsl-h", OBJPROP_TEXT, DoubleToString(bg_hsl.h, 0));
  ObjectSetString(0, "BG-OKhsl-s", OBJPROP_TEXT, DoubleToString(bg_hsl.s, 0));
  ObjectSetString(0, "BG-OKhsl-l", OBJPROP_TEXT, DoubleToString(bg_hsl.l, 0));
  ObjectSetString(0, "BG-OKhsv-h", OBJPROP_TEXT, DoubleToString(bg_hsv.h, 0));
  ObjectSetString(0, "BG-OKhsv-s", OBJPROP_TEXT, DoubleToString(bg_hsv.s, 0));
  ObjectSetString(0, "BG-OKhsv-v", OBJPROP_TEXT, DoubleToString(bg_hsv.v, 0)); }
 else {
  ObjectSetString(0, "FG-RGB-R", OBJPROP_TEXT, DoubleToString(fg_rgb.r, 0));
  ObjectSetString(0, "FG-RGB-G", OBJPROP_TEXT, DoubleToString(fg_rgb.g, 0));
  ObjectSetString(0, "FG-RGB-B", OBJPROP_TEXT, DoubleToString(fg_rgb.b, 0));
  ObjectSetString(0, "FG-OKhsl-h", OBJPROP_TEXT, DoubleToString(fg_hsl.h, 0));
  ObjectSetString(0, "FG-OKhsl-s", OBJPROP_TEXT, DoubleToString(fg_hsl.s, 0));
  ObjectSetString(0, "FG-OKhsl-l", OBJPROP_TEXT, DoubleToString(fg_hsl.l, 0));
  ObjectSetString(0, "FG-OKhsv-h", OBJPROP_TEXT, DoubleToString(fg_hsv.h, 0));
  ObjectSetString(0, "FG-OKhsv-s", OBJPROP_TEXT, DoubleToString(fg_hsv.s, 0));
  ObjectSetString(0, "FG-OKhsv-v", OBJPROP_TEXT, DoubleToString(fg_hsv.v, 0)); } }
//+------------------------------------------------------------------+
//| SelectParameter                                                  |
//+------------------------------------------------------------------+
void SelectParameter(
 string object_name,
 bool   bg
) {
 if(selected_parameter == object_name) {
  return; }
 if(selected_parameter != NULL)        {
  DeselectParameter(selected_parameter, selected_parameter_bg); }
 selected_parameter = object_name;
 selected_parameter_bg = bg;
 selected_parameter_value = GetParameterValue(object_name);
 reset_parameter_value = true;
 if(bg) {
  ObjectSetInteger(0, object_name, OBJPROP_COLOR, bg_clr);
  ObjectSetInteger(0, object_name, OBJPROP_BGCOLOR, bg_txt_clr);
  ObjectSetInteger(0, object_name, OBJPROP_BORDER_COLOR, bg_txt_clr); }
 else {
  ObjectSetInteger(0, object_name, OBJPROP_COLOR, fg_clr);
  ObjectSetInteger(0, object_name, OBJPROP_BGCOLOR, fg_txt_clr);
  ObjectSetInteger(0, object_name, OBJPROP_BORDER_COLOR, fg_txt_clr); } }
//+------------------------------------------------------------------+
//| DeselectParameter                                                |
//+------------------------------------------------------------------+
void DeselectParameter(
 string object_name,
 bool   bg
) {
 selected_parameter = NULL;
 if(bg) {
  ObjectSetInteger(0, object_name, OBJPROP_COLOR, bg_txt_clr);
  ObjectSetInteger(0, object_name, OBJPROP_BGCOLOR, bg_clr);
  ObjectSetInteger(0, object_name, OBJPROP_BORDER_COLOR, bg_clr); }
 else {
  ObjectSetInteger(0, object_name, OBJPROP_COLOR, fg_txt_clr);
  ObjectSetInteger(0, object_name, OBJPROP_BGCOLOR, fg_clr);
  ObjectSetInteger(0, object_name, OBJPROP_BORDER_COLOR, fg_clr); } }
//+------------------------------------------------------------------+
//| ApplyColor                                                       |
//+------------------------------------------------------------------+
void ApplyColor(
 bool bg
) {
 if(bg) {
  bg_clr = (color)(uchar(bg_rgb.b) << 16) | (uchar(bg_rgb.g) << 8) | uchar(bg_rgb.r);
  if(GetRelativeLuminance(bg_clr) < 0.45) {
   bg_txt_clr = clrWhite; }
  else                                  {
   bg_txt_clr = clrBlack; }
  ChartSetInteger(0, CHART_COLOR_BACKGROUND, bg_clr);
  ObjectSetInteger(0, "BG", OBJPROP_BGCOLOR, bg_clr);
  ObjectSetInteger(0, "BG-RIGHT", OBJPROP_BGCOLOR, bg_clr);
  ObjectSetInteger(0, "BG-BOTTOM", OBJPROP_BGCOLOR, bg_clr);
  EditSetColor("BG-RGB", bg_txt_clr, bg_clr);
  EditSetColor("BG-OKhsl", bg_txt_clr, bg_clr);
  EditSetColor("BG-OKhsv", bg_txt_clr, bg_clr);
  EditSetColor("BG-RGB-R", bg_txt_clr, bg_clr);
  EditSetColor("BG-RGB-G", bg_txt_clr, bg_clr);
  EditSetColor("BG-RGB-B", bg_txt_clr, bg_clr);
  EditSetColor("BG-OKhsl-h", bg_txt_clr, bg_clr);
  EditSetColor("BG-OKhsl-s", bg_txt_clr, bg_clr);
  EditSetColor("BG-OKhsl-l", bg_txt_clr, bg_clr);
  EditSetColor("BG-OKhsv-h", bg_txt_clr, bg_clr);
  EditSetColor("BG-OKhsv-s", bg_txt_clr, bg_clr);
  EditSetColor("BG-OKhsv-v", bg_txt_clr, bg_clr); }
 else {
  fg_clr = (color)(uchar(fg_rgb.b) << 16) | (uchar(fg_rgb.g) << 8) | uchar(fg_rgb.r);
  if(GetRelativeLuminance(fg_clr) < 0.45) {
   fg_txt_clr = clrWhite; }
  else                                  {
   fg_txt_clr = clrBlack; }
  ObjectSetInteger(0, "FG", OBJPROP_BGCOLOR, fg_clr);
  EditSetColor("FG-RGB", fg_txt_clr, fg_clr);
  EditSetColor("FG-OKhsl", fg_txt_clr, fg_clr);
  EditSetColor("FG-OKhsv", fg_txt_clr, fg_clr);
  EditSetColor("FG-RGB-R", fg_txt_clr, fg_clr);
  EditSetColor("FG-RGB-G", fg_txt_clr, fg_clr);
  EditSetColor("FG-RGB-B", fg_txt_clr, fg_clr);
  EditSetColor("FG-OKhsl-h", fg_txt_clr, fg_clr);
  EditSetColor("FG-OKhsl-s", fg_txt_clr, fg_clr);
  EditSetColor("FG-OKhsl-l", fg_txt_clr, fg_clr);
  EditSetColor("FG-OKhsv-h", fg_txt_clr, fg_clr);
  EditSetColor("FG-OKhsv-s", fg_txt_clr, fg_clr);
  EditSetColor("FG-OKhsv-v", fg_txt_clr, fg_clr); } }
//+------------------------------------------------------------------+
//| Resize                                                           |
//+------------------------------------------------------------------+
void Resize() {
 int current_chart_width = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0);
 int current_chart_height = (int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS, 0);
 if(current_chart_width == chart_width && current_chart_height == chart_height) {
  return; }
 chart_width = current_chart_width;
 chart_height = current_chart_height;
 int width = (int)MathRound(double(current_chart_width) / 2.0) - fg_indent;
 int height = current_chart_height - SCALE_ROUND(48);
 int x = (int)MathRound(double(current_chart_width) / 2.0);
 int y = fg_indent;
 RectLabelResize("BG", 0, 0, chart_width, chart_height);
 RectLabelResize("BG-RIGHT", x + width - 2, y, fg_indent + 20, height);
 RectLabelResize("BG-BOTTOM", x, y + height - 2, width + fg_indent + 20, fg_indent + 20);
 RectLabelResize("FG", x, fg_indent, width, height);
 EditSetPosition("FG-RGB", x + x_indent_0, y_indent_1);
 EditSetPosition("FG-OKhsl", x + x_indent_0, y_indent_2);
 EditSetPosition("FG-OKhsv", x + x_indent_0, y_indent_3);
 EditSetPosition("FG-RGB-R", x + x_indent_1, y_indent_1);
 EditSetPosition("FG-RGB-G", x + x_indent_2, y_indent_1);
 EditSetPosition("FG-RGB-B", x + x_indent_3, y_indent_1);
 EditSetPosition("FG-OKhsl-h", x + x_indent_1, y_indent_2);
 EditSetPosition("FG-OKhsl-s", x + x_indent_2, y_indent_2);
 EditSetPosition("FG-OKhsl-l", x + x_indent_3, y_indent_2);
 EditSetPosition("FG-OKhsv-h", x + x_indent_1, y_indent_3);
 EditSetPosition("FG-OKhsv-s", x + x_indent_2, y_indent_3);
 EditSetPosition("FG-OKhsv-v", x + x_indent_3, y_indent_3); }
//+------------------------------------------------------------------+
//| RectLabelCreate                                                  |
//+------------------------------------------------------------------+
void RectLabelCreate(
 const string name,
 const int    sub_window,
 const int    x,
 const int    y,
 const int    width,
 const int    height,
 const color  back_clr,
 const long   z_order
) {
 if(!ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, sub_window, 0, 0)) {
  Alert("Error: \"" + name + "\" can not be created."); }
 ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
 ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
 ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
 ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
 ObjectSetInteger(0, name, OBJPROP_BGCOLOR, back_clr);
 ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
 ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
 ObjectSetInteger(0, name, OBJPROP_WIDTH, 0);
 ObjectSetInteger(0, name, OBJPROP_BACK, false);
 ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
 ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
 ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
 ObjectSetInteger(0, name, OBJPROP_ZORDER, z_order); }
//+------------------------------------------------------------------+
//| RectLabelResize                                                  |
//+------------------------------------------------------------------+
void RectLabelResize(
 string name,
 int    x,
 int    y,
 int    width,
 int    height
) {
 ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
 ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
 ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
 ObjectSetInteger(0, name, OBJPROP_YSIZE, height); }
//+------------------------------------------------------------------+
//| EditCreate                                                       |
//+------------------------------------------------------------------+
bool EditCreate(
 const string          name,
 const int             sub_window,
 const int             x,
 const int             y,
 const int             width,
 const int             height,
 const string          text,
 const ENUM_ALIGN_MODE align,
 const bool            read_only,
 const color           clr,
 const color           back_clr,
 const long            z_order
) {
 if(!ObjectCreate(0, name, OBJ_EDIT, sub_window, 0, 0)) {
  Alert("Error: \"" + name + "\" can not be created."); }
 ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
 ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
 ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
 ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
 ObjectSetString(0, name, OBJPROP_TEXT, text);
 ObjectSetString(0, name, OBJPROP_FONT, "Consolas");
 ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 20);
 ObjectSetInteger(0, name, OBJPROP_ALIGN, align);
 ObjectSetInteger(0, name, OBJPROP_READONLY, read_only);
 ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
 ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
 ObjectSetInteger(0, name, OBJPROP_BGCOLOR, back_clr);
 ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, back_clr);
 ObjectSetInteger(0, name, OBJPROP_BACK, false);
 ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
 ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
 ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
 ObjectSetInteger(0, name, OBJPROP_ZORDER, z_order);
 return(true); }
//+------------------------------------------------------------------+
//| EditSetPosition                                                  |
//+------------------------------------------------------------------+
void EditSetPosition(
 string name,
 int    x,
 int    y
) {
 ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
 ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y); }
//+------------------------------------------------------------------+
//| EditSetColor                                                     |
//+------------------------------------------------------------------+
void EditSetColor(
 string name,
 color  clr,
 color  back_clr
) {
 ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
 ObjectSetInteger(0, name, OBJPROP_BGCOLOR, back_clr);
 ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, back_clr); }
//+------------------------------------------------------------------+
//| Linear RGB conversion                                            |
//+------------------------------------------------------------------+
double rgb_to_linear(
 uchar u
) {
 double d = double(u) / 255.0;
 return((0.04045 < d) ? (MathPow((d + 0.055) / 1.055, 2.4)) : (d / 12.92)); }
//+------------------------------------------------------------------+
//| GetRelativeLuminance                                             |
//+------------------------------------------------------------------+
double GetRelativeLuminance(
 color clr
) {
 return(0.2126 * rgb_to_linear(uchar(clr)) + 0.7152 * rgb_to_linear(uchar(clr >> 8)) + 0.0722 * rgb_to_linear(uchar(clr >> 16))); }
//+------------------------------------------------------------------+
//| ColorToRGB                                                       |
//+------------------------------------------------------------------+
void ColorToRGB(
 color  clr,
 RGB   &rgb
) {
 rgb.r = uchar(clr);
 rgb.g = uchar(clr >> 8);
 rgb.b = uchar(clr >> 16); }
//+------------------------------------------------------------------+
