//+------------------------------------------------------------------+
//|                                              Smooth Gradient.mqh |
//|                                  Copyright 2023, Maxim Savochkin |
//|                 https://www.mql5.com/en/users/m_savochkin99/news |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Maxim Savochkin"
#property link      "https://www.mql5.com/en/users/m_savochkin99/news"
#include  <OK Color Space.mqh>
//+------------------------------------------------------------------+
//| GetGradientValue                                                 |
//+------------------------------------------------------------------+
color GetGradientValue(
 OKhsl &color_first,
 OKhsl &color_last,
 double value_first,
 double value_last,
 double value_current,
 bool   major_arc = false
) {
//--- check OKhsl values
 color_first.h = MathMax(0.f, MathMin(360.f, color_first.h));
 color_first.s = MathMax(0.f, MathMin(100.f, color_first.s));
 color_first.l = MathMax(0.f, MathMin(100.f, color_first.l));
 color_last.h = MathMax(0.f, MathMin(360.f, color_last.h));
 color_last.s = MathMax(0.f, MathMin(100.f, color_last.s));
 color_last.l = MathMax(0.f, MathMin(100.f, color_last.l));
//--- check value_first and value_last
 if(value_first > value_last) {
  //--- swap colors and values
  OKhsl  temp_color = color_first;
  double temp_value = value_first;
  color_first = color_last;
  color_last = temp_color;
  value_first = value_last;
  value_last = temp_value; }
//--- check value_current
 if(value_current <= value_first) {
  return(OKhslToColor(color_first)); }
 if(value_current >= value_last)  {
  return(OKhslToColor(color_last)); }
//--- calculate hue, saturation and lightness delta
 double h_delta = MathAbs(color_last.h - color_first.h);
 if(major_arc) {
  if(h_delta < 180) {
   h_delta = 360 - h_delta;
   if(color_first.h < color_last.h) {
    h_delta = -h_delta; } }
  else {
   if(color_last.h < color_first.h) {
    h_delta = -h_delta; } } }
 else {
  if(h_delta < 180) {
   if(color_last.h < color_first.h) {
    h_delta = -h_delta; } }
  else {
   h_delta = 360 - h_delta;
   if(color_first.h < color_last.h) {
    h_delta = -h_delta; } } }
 double s_delta = color_last.s - color_first.s;
 double l_delta = color_last.l - color_first.l;
//--- calculate gradient color
 float  h, s, l;
 double value_coeff = (value_current - value_first) / (value_last - value_first);
 h = (float)NormalizeDouble(color_first.h + h_delta * value_coeff, FLT_DIG);
 if(h < 0.f)   {
  h += 360.f; }
 if(h > 360.f) {
  h -= 360.f; }
 s = (float)NormalizeDouble(color_first.s + s_delta * value_coeff, FLT_DIG);
 l = (float)NormalizeDouble(color_first.l + l_delta * value_coeff, FLT_DIG);
//--- return
 return(OKhslToColor(h, s, l)); }
//+------------------------------------------------------------------+
//| GetGradientValues                                                |
//+------------------------------------------------------------------+
int GetGradientValues(
 OKhsl  &color_first,
 OKhsl  &color_last,
 double  value_first,
 double  value_last,
 double &values_input[],
 color  &colors_output[],
 bool    major_arc = false
) {
 if(!ArrayIsDynamic(colors_output)) {
  return(0); }
 int array_size = ArraySize(values_input);
 if(array_size == 0) {
  return(0); }
//--- check OKhsl values
 color_first.h = MathMax(0.f, MathMin(360.f, color_first.h));
 color_first.s = MathMax(0.f, MathMin(100.f, color_first.s));
 color_first.l = MathMax(0.f, MathMin(100.f, color_first.l));
 color_last.h = MathMax(0.f, MathMin(360.f, color_last.h));
 color_last.s = MathMax(0.f, MathMin(100.f, color_last.s));
 color_last.l = MathMax(0.f, MathMin(100.f, color_last.l));
//--- check value_first and value_last
 if(value_first > value_last) {
  //--- swap colors and values
  OKhsl  temp_color = color_first;
  double temp_value = value_first;
  color_first = color_last;
  color_last = temp_color;
  value_first = value_last;
  value_last = temp_value; }
 double value_min = values_input[ArrayMinimum(values_input)];
 double value_max = values_input[ArrayMaximum(values_input)];
 if(value_min < value_first) {
  value_first = value_min; }
 if(value_max > value_last)  {
  value_last = value_max; }
//--- calculate hue, saturation and lightness delta
 double h_delta = MathAbs(color_last.h - color_first.h);
 if(major_arc) {
  if(h_delta < 180) {
   h_delta = 360 - h_delta;
   if(color_first.h < color_last.h) {
    h_delta = -h_delta; } }
  else {
   if(color_last.h < color_first.h) {
    h_delta = -h_delta; } } }
 else {
  if(h_delta < 180) {
   if(color_last.h < color_first.h) {
    h_delta = -h_delta; } }
  else {
   h_delta = 360 - h_delta;
   if(color_first.h < color_last.h) {
    h_delta = -h_delta; } } }
 double s_delta = color_last.s - color_first.s;
 double l_delta = color_last.l - color_first.l;
//--- calculate gradient colors
 ArrayResize(colors_output, array_size);
 float  h, s, l;
 double value_coeff;
 for(int i = 0; i < array_size; i++) {
  value_coeff = (values_input[i] - value_first) / (value_last - value_first);
  h = (float)NormalizeDouble(color_first.h + h_delta * value_coeff, FLT_DIG);
  if(h < 0.f)   {
   h += 360.f; }
  if(h > 360.f) {
   h -= 360.f; }
  s = (float)NormalizeDouble(color_first.s + s_delta * value_coeff, FLT_DIG);
  l = (float)NormalizeDouble(color_first.l + l_delta * value_coeff, FLT_DIG);
  colors_output[i] = OKhslToColor(h, s, l); }
 return(array_size); }
//+------------------------------------------------------------------+
//| GetGradientSteps                                                 |
//+------------------------------------------------------------------+
void GetGradientSteps(
 OKhsl &color_first,
 OKhsl &color_last,
 int    step_count,
 color &gradient_steps[],
 bool   major_arc = false
) {
 if(!ArrayIsDynamic(gradient_steps)) {
  return; }
//--- check OKhsl values
 color_first.h = MathMax(0.f, MathMin(360.f, color_first.h));
 color_first.s = MathMax(0.f, MathMin(100.f, color_first.s));
 color_first.l = MathMax(0.f, MathMin(100.f, color_first.l));
 color_last.h = MathMax(0.f, MathMin(360.f, color_last.h));
 color_last.s = MathMax(0.f, MathMin(100.f, color_last.s));
 color_last.l = MathMax(0.f, MathMin(100.f, color_last.l));
//--- check step_count
 if(step_count <= 2) {
  ArrayResize(gradient_steps, 2);
  gradient_steps[0] = OKhslToColor(color_first.h, color_first.s, color_first.l);
  gradient_steps[1] = OKhslToColor(color_last.h, color_last.s, color_last.l);
  return; }
//--- calculate hue, saturation and lightness step
 double h_step, s_step, l_step;
 double h_delta = MathAbs(color_last.h - color_first.h);
 if(major_arc) {
  if(h_delta < 180) {
   h_step = (360 - h_delta) / double(step_count - 1);
   if(color_first.h < color_last.h) {
    h_step = -h_step; } }
  else {
   h_step = h_delta / double(step_count - 1);
   if(color_last.h < color_first.h) {
    h_step = -h_step; } } }
 else {
  if(h_delta < 180) {
   h_step = h_delta / double(step_count - 1);
   if(color_last.h < color_first.h) {
    h_step = -h_step; } }
  else {
   h_step = (360 - h_delta) / double(step_count - 1);
   if(color_first.h < color_last.h) {
    h_step = -h_step; } } }
 s_step = (color_last.s - color_first.s) / double(step_count - 1);
 l_step = (color_last.l - color_first.l) / double(step_count - 1);
//--- calculate gradient colors
 ArrayResize(gradient_steps, step_count);
 gradient_steps[0] = OKhslToColor(color_first.h, color_first.s, color_first.l);
 gradient_steps[step_count - 1] = OKhslToColor(color_last.h, color_last.s, color_last.l);
 float h, s, l;
 for(int i = 1; i < step_count - 1; i++) {
  h = color_first.h + (float)NormalizeDouble(double(i) * h_step, FLT_DIG);
  if(h < 0)   {
   h += 360; }
  if(h > 360) {
   h -= 360; }
  s = color_first.s + (float)NormalizeDouble(double(i) * s_step, FLT_DIG);
  l = color_first.l + (float)NormalizeDouble(double(i) * l_step, FLT_DIG);
  gradient_steps[i] = OKhslToColor(h, s, l); } }
//+------------------------------------------------------------------+
