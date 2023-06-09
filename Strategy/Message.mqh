//+------------------------------------------------------------------+
//|                                                         Logs.mqh |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
#include <Object.mqh>
#include <Arrays\ArrayObj.mqh>

#define UNKNOW_SOURCE "unknown"     // An unknown source of messages
//+------------------------------------------------------------------+
//| Message type                                                     |
//+------------------------------------------------------------------+
enum ENUM_MESSAGE_TYPE
  {
   MESSAGE_INFO,                    // Informational message
   MESSAGE_WARNING,                 // Warning message
   MESSAGE_ERROR                    // Error message
  };
//+------------------------------------------------------------------+
//| Message passed to the logging class                              |
//+------------------------------------------------------------------+
class CMessage : public CObject
  {
private:
   ENUM_MESSAGE_TYPE m_type;               // Message type
   string            m_source;             // Message source
   string            m_text;               // Message text
   int               m_system_error_id;    // Creates an ID of a SYSTEM error.
   int               m_retcode;            // Contains a trade server return code
   datetime          m_server_time;        // Trade server time at the moment of message creation
   datetime          m_local_time;         // Local time at the moment of message creation
   void              Init(ENUM_MESSAGE_TYPE type,string source,string text);
public:
                     CMessage(void);
                     CMessage(ENUM_MESSAGE_TYPE type);
                     CMessage(ENUM_MESSAGE_TYPE type,string source,string text);
   void              Type(ENUM_MESSAGE_TYPE type);
   ENUM_MESSAGE_TYPE Type(void);
   void              Source(string source);
   string            Source(void);
   void              Text(string text);
   string            Text(void);
   datetime          TimeServer(void);
   datetime          TimeLocal();
   void              SystemErrorID(int error);
   int               SystemErrorID();
   void              Retcode(int retcode);
   int               Retcode(void);
   string            ToConsoleType(void);
   string            ToCSVType(void);
  };
//+------------------------------------------------------------------+
//| By default no need to fill the time, it is created               |
//| automatically at the moment of object createion.                 |
//+------------------------------------------------------------------+
CMessage::CMessage(void)
  {
   Init(MESSAGE_INFO,UNKNOW_SOURCE,"");
  }
//+------------------------------------------------------------------+
//| Creates a message of a predefined type, message source and       |
//| text.                                                            |
//+------------------------------------------------------------------+
CMessage::CMessage(ENUM_MESSAGE_TYPE type,string source,string text)
  {
   Init(type,source,text);
  }
//+------------------------------------------------------------------+
//| Creates a message of a predefined type.                          |
//+------------------------------------------------------------------+
CMessage::CMessage(ENUM_MESSAGE_TYPE type)
  {
   Init(type,UNKNOW_SOURCE,"");
  }
//+------------------------------------------------------------------+
//| Serves as a basic constructor.                                   |
//+------------------------------------------------------------------+
void CMessage::Init(ENUM_MESSAGE_TYPE type,string source,string text)
  {
   m_server_time= TimeCurrent();
   m_local_time = TimeLocal();
   m_type=type;
   m_source=source;
   m_text=text;
   m_system_error_id=GetLastError();

  }
//+------------------------------------------------------------------+
//| Returns the message type.                                        |
//+------------------------------------------------------------------+
ENUM_MESSAGE_TYPE CMessage::Type(void)
  {
   return m_type;
  }
//+------------------------------------------------------------------+
//| Sets the message source.                                         |
//+------------------------------------------------------------------+
void CMessage::Source(string source)
  {
   m_source=source;
  }
//+------------------------------------------------------------------+
//| Returns the message source.                                      |
//+------------------------------------------------------------------+
string CMessage::Source(void)
  {
   return m_source;
  }
//+------------------------------------------------------------------+
//| Sets message contents.                                           |
//+------------------------------------------------------------------+
void CMessage::Text(string text)
  {
   m_text=text;
  }
//+------------------------------------------------------------------+
//| Returns the message contents.                                    |
//+------------------------------------------------------------------+
string CMessage::Text(void)
  {
   return m_text;
  }
//+------------------------------------------------------------------+
//| Returns server time at the moment of message creation            |
//+------------------------------------------------------------------+
datetime CMessage::TimeServer(void)
  {
   return m_server_time;
  }
//+------------------------------------------------------------------+
//| Returns local time at the moment of message creation.            |
//+------------------------------------------------------------------+
datetime CMessage::TimeLocal(void)
  {
   return m_local_time;
  }
//+------------------------------------------------------------------+
//| Returns message string to display in the terminal window         |
//+------------------------------------------------------------------+
string CMessage::ToConsoleType(void)
  {
   string dt= ";";
   string t = EnumToString(m_type);
   t=StringSubstr(t,8);
   string text=t+dt+m_source+dt+m_text+dt+
               TimeToString(m_server_time,TIME_DATE|TIME_MINUTES|TIME_SECONDS);
   return text;
  }
//+------------------------------------------------------------------+
//| Returns message string to add to the log file.                   |
//+------------------------------------------------------------------+
string CMessage::ToCSVType(void)
  {
   string d="\t";  //Separator of message columns
   string msg=TimeToString(m_server_time,TIME_DATE|TIME_MINUTES|TIME_SECONDS)+d+EnumToString(m_type)+d+m_source+d+m_text;
   return msg;
  }
//+------------------------------------------------------------------+
//| Returns code of the saved error.                                 |
//+------------------------------------------------------------------+
int CMessage::SystemErrorID(void)
  {
   return m_system_error_id;
  }
//+------------------------------------------------------------------+
//| Sets error code corresponding to the message.              This  |
//| can be a system or user error code.                              |
//| NOTE: The last error is set automatically while a message        |
//| is being created. That is why you should call this method      |
//| only in special cases.                                           |
//+------------------------------------------------------------------+
void CMessage::SystemErrorID(int error)
  {
   m_system_error_id=error;
  }
//+------------------------------------------------------------------+
//| Sets the trade server response code. Unlike                      |
//| SystemErrorID, requires explicit setting, since CMessage has     |
//| no access to trade server response.                              |
//+------------------------------------------------------------------+
void CMessage::Retcode(int retcode)
  {
   m_retcode=retcode;
  }
//+------------------------------------------------------------------+
//| Returns the user defined response code received from a trade     |
//| server.  This field needs to be analyzed only in cases where     |
//| the received message is connected with trading actions.          |
//+------------------------------------------------------------------+
int CMessage::Retcode(void)
  {
   return m_retcode;
  }
//+------------------------------------------------------------------+
