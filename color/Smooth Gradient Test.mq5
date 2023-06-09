//+------------------------------------------------------------------+
//|                                         Smooth Gradient Test.mq5 |
//|                                  Copyright 2023, Maxim Savochkin |
//|                 https://www.mql5.com/en/users/m_savochkin99/news |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Maxim Savochkin"
#property link      "https://www.mql5.com/en/users/m_savochkin99/news"
#include  <Canvas/Canvas.mqh>
#include  <Smooth Gradient.mqh>
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
//--- gradient
int     gradient_y = SCALE_ROUND(40);
int     gradient_width;
int     gradient_height = SCALE_ROUND(200);
color   gradient_colors[];
bool    gradient_major_arc = false;
CCanvas gradient;
//--- parameter indents
int parameter_width = SCALE_ROUND(52);
int parameter_height = SCALE_ROUND(28);
int x_indent_L1 = SCALE_ROUND(40);
int x_indent_L2 = x_indent_L1 + SCALE_ROUND(144);
int x_indent_L3 = x_indent_L2 + parameter_width;
int x_indent_R1 = SCALE_ROUND(200);
int x_indent_R2 = x_indent_R1 - SCALE_ROUND(144);
int y_indent_1 = gradient_y + gradient_height + SCALE_ROUND(32);
int y_indent_2 = y_indent_1 + parameter_height + SCALE_ROUND(4);
int y_indent_3 = y_indent_2 + parameter_height + SCALE_ROUND(4);
int y_indent_4 = y_indent_3 + parameter_height + SCALE_ROUND(16);
int x_R1, x_R2;
//--- colors
color bg_clr = C'17,23,26';
color txt_clr = clrWhite;
color txt_clr_gray = clrDimGray;
color clr_left;
color clr_right;
OKhsl hsl_left = {260, 100, 50 };
OKhsl hsl_right = {350, 100, 60 };
//--- selected parameter info
string selected_parameter;
string selected_parameter_value;
bool   selected_parameter_side;  // false-left side, true-right side
bool   reset_parameter_value;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
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
 chart_width = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0);
 chart_height = (int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS, 0);
 RectLabelCreate("BG", 0, 0, 0, chart_width, chart_height, bg_clr, 0);
 gradient_width = MathMax(SCALE_ROUND(520), chart_width - 2 * x_indent_L1);
 gradient.CreateBitmapLabel(0, 0, "GRADIENT", x_indent_L1, gradient_y, gradient_width, gradient_height, COLOR_FORMAT_XRGB_NOALPHA);
 UpdateGradient();
 EditCreate("Hue LEFT", 0, x_indent_L1, y_indent_1, SCALE_ROUND(200), parameter_height, "Hue:", ALIGN_LEFT, true, txt_clr, bg_clr, 0);
 EditCreate("Saturation LEFT", 0, x_indent_L1, y_indent_2, SCALE_ROUND(200), parameter_height, "Saturation:", ALIGN_LEFT, true, txt_clr, bg_clr, 0);
 EditCreate("Lightness LEFT", 0, x_indent_L1, y_indent_3, SCALE_ROUND(200), parameter_height, "Lightness:", ALIGN_LEFT, true, txt_clr, bg_clr, 0);
 EditCreate("Major Arc", 0, x_indent_L1, y_indent_4, SCALE_ROUND(200), parameter_height, "Major Arc:", ALIGN_LEFT, true, txt_clr, bg_clr, 0);
 EditCreate("Major Arc ON", 0, x_indent_L2, y_indent_4, parameter_width, parameter_height, "On", ALIGN_CENTER, true, txt_clr_gray, bg_clr, 1);
 EditCreate("Major Arc OFF", 0, x_indent_L3, y_indent_4, parameter_width, parameter_height, "Off", ALIGN_CENTER, true, clrOrangeRed, bg_clr, 1);
 EditCreate("OKhsl-h LEFT", 0, x_indent_L2, y_indent_1, parameter_width, parameter_height, DoubleToString(hsl_left.h, 0), ALIGN_CENTER, true, bg_clr, txt_clr, 1);
 EditCreate("OKhsl-s LEFT", 0, x_indent_L2, y_indent_2, parameter_width, parameter_height, DoubleToString(hsl_left.s, 0), ALIGN_CENTER, true, txt_clr, bg_clr, 1);
 EditCreate("OKhsl-l LEFT", 0, x_indent_L2, y_indent_3, parameter_width, parameter_height, DoubleToString(hsl_left.l, 0), ALIGN_CENTER, true, txt_clr, bg_clr, 1);
 x_R1 = x_indent_L1 + gradient_width - x_indent_R1;
 x_R2 = x_indent_L1 + gradient_width - x_indent_R2;
 EditCreate("Hue RIGHT", 0, x_R1, y_indent_1, SCALE_ROUND(200), parameter_height, "Hue:", ALIGN_LEFT, true, txt_clr, bg_clr, 0);
 EditCreate("Saturation RIGHT", 0, x_R1, y_indent_2, SCALE_ROUND(200), parameter_height, "Saturation:", ALIGN_LEFT, true, txt_clr, bg_clr, 0);
 EditCreate("Lightness RIGHT", 0, x_R1, y_indent_3, SCALE_ROUND(200), parameter_height, "Lightness:", ALIGN_LEFT, true, txt_clr, bg_clr, 0);
 EditCreate("OKhsl-h RIGHT", 0, x_R2, y_indent_1, parameter_width, parameter_height, DoubleToString(hsl_right.h, 0), ALIGN_CENTER, true, txt_clr, bg_clr, 1);
 EditCreate("OKhsl-s RIGHT", 0, x_R2, y_indent_2, parameter_width, parameter_height, DoubleToString(hsl_right.s, 0), ALIGN_CENTER, true, txt_clr, bg_clr, 1);
 EditCreate("OKhsl-l RIGHT", 0, x_R2, y_indent_3, parameter_width, parameter_height, DoubleToString(hsl_right.l, 0), ALIGN_CENTER, true, txt_clr, bg_clr, 1);
//--- selected parameter info
 selected_parameter = "OKhsl-h LEFT";
 selected_parameter_side = false;
 selected_parameter_value = DoubleToString(hsl_left.h, 0);
 reset_parameter_value = true;
 ChartRedraw();
//---
 return(INIT_SUCCEEDED); }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
//--- delete interface
 gradient.Destroy();
 ObjectDelete(0, "BG");
 ObjectDelete(0, "Hue LEFT");
 ObjectDelete(0, "Saturation LEFT");
 ObjectDelete(0, "Lightness LEFT");
 ObjectDelete(0, "Major Arc");
 ObjectDelete(0, "Major Arc ON");
 ObjectDelete(0, "Major Arc OFF");
 ObjectDelete(0, "Hue RIGHT");
 ObjectDelete(0, "Saturation RIGHT");
 ObjectDelete(0, "Lightness RIGHT");
 ObjectDelete(0, "OKhsl-h LEFT");
 ObjectDelete(0, "OKhsl-s LEFT");
 ObjectDelete(0, "OKhsl-l LEFT");
 ObjectDelete(0, "OKhsl-h RIGHT");
 ObjectDelete(0, "OKhsl-s RIGHT");
 ObjectDelete(0, "OKhsl-l RIGHT");
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
  if(sparam == "OKhsl-h LEFT" || sparam == "OKhsl-s LEFT" || sparam == "OKhsl-l LEFT") {
   if(selected_parameter_side && selected_parameter != NULL) {
    UpdateGradient(); }
   SelectParameter(sparam, false);
   ChartRedraw(); }
  else if(sparam == "OKhsl-h RIGHT" || sparam == "OKhsl-s RIGHT" || sparam == "OKhsl-l RIGHT") {
   if(!selected_parameter_side && selected_parameter != NULL) {
    UpdateGradient(); }
   SelectParameter(sparam, true);
   ChartRedraw(); }
  else if(sparam == "Major Arc ON") {
   if(!gradient_major_arc) {
    gradient_major_arc = true;
    EditSetColor("Major Arc ON", clrLimeGreen, bg_clr);
    EditSetColor("Major Arc OFF", txt_clr_gray, bg_clr);
    UpdateGradient();
    ChartRedraw(); } }
  else if(sparam == "Major Arc OFF") {
   if(gradient_major_arc) {
    gradient_major_arc = false;
    EditSetColor("Major Arc ON", txt_clr_gray, bg_clr);
    EditSetColor("Major Arc OFF", clrOrangeRed, bg_clr);
    UpdateGradient();
    ChartRedraw(); } }
  else if((sparam == "BG" || sparam == "GRADIENT" ||
           sparam == "Hue LEFT" || sparam == "Saturation LEFT" || sparam == "Lightness LEFT" ||
           sparam == "Hue RIGHT" || sparam == "Saturation RIGHT" || sparam == "Lightness RIGHT") && selected_parameter != NULL) {
   DeselectParameter(selected_parameter);
   UpdateGradient();
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
   DeselectParameter(selected_parameter);
   UpdateGradient();
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
//| UpdateGradient                                                   |
//+------------------------------------------------------------------+
void UpdateGradient() {
 GetGradientSteps(hsl_left, hsl_right, gradient_width, gradient_colors, gradient_major_arc);
 for(int x = 0; x < gradient_width; x++) {
  for(int y = 0; y < gradient_height; y++) {
   gradient.PixelSet(x, y, ColorToARGB(gradient_colors[x])); } }
 gradient.Update(false); }
//+------------------------------------------------------------------+
//| GetMaxParameterValue                                             |
//+------------------------------------------------------------------+
int GetMaxParameterValue(
 string object_name
) {
 if(object_name == "OKhsl-h LEFT" || object_name == "OKhsl-h RIGHT") {
  return(360); }
 if(object_name == "OKhsl-s LEFT" || object_name == "OKhsl-s RIGHT" ||
    object_name == "OKhsl-l LEFT" || object_name == "OKhsl-l RIGHT") {
  return(100); }
 return(0); }
//+------------------------------------------------------------------+
//| GetParameterValue                                                |
//+------------------------------------------------------------------+
string GetParameterValue(
 string object_name
) {
 if(object_name == "OKhsl-h LEFT")  return(DoubleToString(hsl_left.h, 0));
 if(object_name == "OKhsl-s LEFT")  return(DoubleToString(hsl_left.s, 0));
 if(object_name == "OKhsl-l LEFT")  return(DoubleToString(hsl_left.l, 0));
 if(object_name == "OKhsl-h RIGHT") return(DoubleToString(hsl_right.h, 0));
 if(object_name == "OKhsl-s RIGHT") return(DoubleToString(hsl_right.s, 0));
 if(object_name == "OKhsl-l RIGHT") return(DoubleToString(hsl_right.l, 0));
 return(NULL); }
//+------------------------------------------------------------------+
//| SetParameterValue                                                |
//+------------------------------------------------------------------+
void SetParameterValue(
 string object_name,
 float  value
) {
 if(object_name == "OKhsl-h LEFT")  {
  hsl_left.h = value;
  return; }
 if(object_name == "OKhsl-s LEFT")  {
  hsl_left.s = value;
  return; }
 if(object_name == "OKhsl-l LEFT")  {
  hsl_left.l = value;
  return; }
 if(object_name == "OKhsl-h RIGHT") {
  hsl_right.h = value;
  return; }
 if(object_name == "OKhsl-s RIGHT") {
  hsl_right.s = value;
  return; }
 if(object_name == "OKhsl-l RIGHT") {
  hsl_right.l = value;
  return; } }
//+------------------------------------------------------------------+
//| SelectParameter                                                  |
//+------------------------------------------------------------------+
void SelectParameter(
 string object_name,
 bool   side
) {
 if(selected_parameter == object_name) {
  return; }
 if(selected_parameter != NULL)        {
  DeselectParameter(selected_parameter); }
 selected_parameter = object_name;
 selected_parameter_side = side;
 selected_parameter_value = GetParameterValue(object_name);
 reset_parameter_value = true;
 EditSetColor(object_name, bg_clr, txt_clr); }
//+------------------------------------------------------------------+
//| DeselectParameter                                                |
//+------------------------------------------------------------------+
void DeselectParameter(
 string object_name
) {
 selected_parameter = NULL;
 EditSetColor(object_name, txt_clr, bg_clr); }
//+------------------------------------------------------------------+
//| Resize                                                           |
//+------------------------------------------------------------------+
void Resize() {
 int current_chart_width = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS, 0);
 int current_chart_height = (int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS, 0);
 if(current_chart_width == chart_width && current_chart_height == chart_height) {
  return; }
 if(current_chart_width == chart_width) {
  chart_height = current_chart_height;
  RectLabelResize("BG", 0, 0, chart_width, chart_height);
  return; }
 chart_width = current_chart_width;
 chart_height = current_chart_height;
 gradient_width = MathMax(SCALE_ROUND(520), chart_width - 2 * x_indent_L1);
 gradient.Destroy();
 gradient.CreateBitmapLabel(0, 0, "GRADIENT", x_indent_L1, gradient_y, gradient_width, gradient_height, COLOR_FORMAT_XRGB_NOALPHA);
 UpdateGradient();
 x_R1 = x_indent_L1 + gradient_width - x_indent_R1;
 x_R2 = x_indent_L1 + gradient_width - x_indent_R2;
 RectLabelResize("BG", 0, 0, chart_width, chart_height);
 EditSetPosition("Hue RIGHT", x_R1, y_indent_1);
 EditSetPosition("Saturation RIGHT", x_R1, y_indent_2);
 EditSetPosition("Lightness RIGHT", x_R1, y_indent_3);
 EditSetPosition("OKhsl-h RIGHT", x_R2, y_indent_1);
 EditSetPosition("OKhsl-s RIGHT", x_R2, y_indent_2);
 EditSetPosition("OKhsl-l RIGHT", x_R2, y_indent_3); }
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
 ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 16);
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
//+------------------------------------------------------------------+
