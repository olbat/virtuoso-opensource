#!/bin/sh
#  
#  $Id: twcopy.sh,v 1.16.2.3.4.7 2013/01/02 16:15:34 source Exp $
#
#  This file is part of the OpenLink Software Virtuoso Open-Source (VOS)
#  project.
#  
#  Copyright (C) 1998-2013 OpenLink Software
#  
#  This project is free software; you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by the
#  Free Software Foundation; only version 2 of the License, dated June 1991.
#  
#  This program is distributed in the hope that it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#  General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License along
#  with this program; if not, write to the Free Software Foundation, Inc.,
#  51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
#  

LOGFILE=twcopy.output
export LOGFILE
. $VIRTUOSO_TEST/testlib.sh

DS1=$PORT

#PARAMETERS FOR TEST
THOST=localhost
TPORT=$HTTPPORT

LoadSQL()
{
  sql=$1
  uid=${2-dba}
  passwd=${3-dba}
  echo Load $sql  >> $LOGFILE
  $ISQL $PORT $uid $passwd ERRORS=stdout $sql  >> $LOGFILE
  if test $? -ne 0
  then
    echo "***FAILED: Load $sql" >> $LOGFILE
  else
    echo "PASSED: Load $sql" >> $LOGFILE
  fi
}

DoCommand()
{
  command=$1
  uid=${2-dba}
  passwd=${3-dba}
  echo $command  >> $LOGFILE
  $ISQL $PORT $uid $passwd ERRORS=stdout "EXEC=$command"  >> $LOGFILE
  if test $? -ne 0
  then
    echo "***FAILED: $command" >> $LOGFILE
  else
    echo "PASSED: $command" >> $LOGFILE
  fi
}

GenDefPage ()
{
    echo "Creating HTML default page for Web Loader test"
    file=index.html
    cat > $file <<END_PAGE
<html>
<body>
<strong>Page $1</strong><br>
<a href="page1.html">page1</a><br>
<a href="errpage.html">page with errors</a><br>
<img src="image.gif">
</body>
</html>
END_PAGE
    chmod 644 $file
}

GenStartPage ()
{
    echo "Creating HTML start page for Web Loader test"
    file=page1.html
    cat > $file <<END_PAGE
<html>
<body>
<strong>Page 1</strong><br>
<a href="dir1/page2.html">page2</a><br>
<a href="dir1/page3.html">page3</a><br>
<a href="dir2/page8.html">page8</a><br>
<a href="dir2/page9.html">page9</a><br>
<a href="dir3/page14.html">page14</a><br>
<a href="dir3/page15.html">page15</a><br>
</body>
</html>
END_PAGE
    chmod 644 $file
}

GenPage ()
{
    name=$1
    mod=`expr $1 % 2`
    name2=`expr $1 + 2 + $mod`
    name3=`expr $1 + 3 + $mod`
    dir=$2
    echo "Creating HTML middle page $1 at $3"
    file=page$1.html
    cat > $3$file <<END_PAGE
<html>
<body>
<strong>Page $1</strong><br>
<a href="$dir/page$name2.html">page$name2</a><br>
<a href="$dir/page$name3.html">page$name3</a><br>
<a href="/page1.html">Start Page</a>
</body>
</html>
END_PAGE
    chmod 644 $3$file
}

GenEndPage ()
{
    echo "Creating HTML end page $1 at $2"
    file=page$1.html
    cat > $2$file <<END_PAGE
<html>
<body>
<strong>Page $1</strong>
<a href="/page1.html">Start Page</a>
</body>
</html>
END_PAGE
    chmod 644 $2$file
}

GenErrPage ()
{
    echo "Creating HTML page with errors"
    file=errpage.html
    cat > $file <<END_PAGE
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<!--NewPage-->
<html>
<head>
<!-- Generated by javadoc on Tue Jun 15 12:38:38 GMT 1999 -->
<title>
  Class virtuoso.jdbc.VirtuosoBlob
</title>
</head>
<body>
<p>&</p>
<a name="_top_"></a>
<pre>
<a href="packages.html">All Packages</a>  <a href="tree.html">Class Hierarchy</a>  <a href="Package-virtuoso.jdbc.html">This Package</a>  <a href="virtuoso.jdbc.Types.html#_top_">Previous</a>  <a href="virtuoso.jdbc.VirtuosoCallableStatement.html#_top_">Next</a>  <a href="AllNames.html">Index</a></pre>
<hr>
<h1>
  Class virtuoso.jdbc.VirtuosoBlob
</h1>
<pre>
java.lang.Object
   |
   +----virtuoso.jdbc.VirtuosoBlob
</pre>
<hr>
<dl>
  <dt> public class <b>VirtuosoBlob</b>
  <dt> extends Object
</dl>
The VirtuosoBlob class is an implementation of the Blob
 interface in the JDBC API that represents a Blob object in SQL.
 This is a JDBC 2.0 extension for the JDBC 1.2 driver.
<p>
<dl>
  <dt> <b>Version:</b>
  <dd> 1.0 (JDBC API 1.2 implementation)
</dl>
<hr>
<a name="index"></a>
<h2>
  <img src="images/method-index.gif" width=207 height=38 alt="Method Index">
</h2>
<dl>
  <dt> <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
	<a href="#getAsciiStream()"><b>getAsciiStream</b></a>()
  <dd>  Gets the <code>CLOB</code> value designated by this <code>Clob</code>
 object as a stream of Ascii bytes.
  <dt> <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
	<a href="#getBinaryStream()"><b>getBinaryStream</b></a>()
  <dd>  Retrieves the <code>BLOB</code> designated by this
 <code>Blob</code> instance as a stream.
  <dt> <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
	<a href="#getBytes(long, int)"><b>getBytes</b></a>(long, int)
  <dd>  Returns as an array of bytes part or all of the <code>BLOB</code>
 value that this <code>Blob</code> object designates.
  <dt> <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
	<a href="#getCharacterStream()"><b>getCharacterStream</b></a>()
  <dd>  Gets the <code>Clob</code> contents as a Unicode stream.
  <dt> <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
	<a href="#getSubString(long, int)"><b>getSubString</b></a>(long, int)
  <dd>  Returns a copy of the specified substring
 in the <code>CLOB</code> value
 designated by this <code>Clob</code> object.
  <dt> <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
	<a href="#hashCode()"><b>hashCode</b></a>()
  <dd>  Returns a hash code value for the object.
  <dt> <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
	<a href="#length()"><b>length</b></a>()
  <dd>  Returns the number of bytes in the BLOB value
 designated by this Blob object.
  <dt> <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
	<a href="#position(byte[], long)"><b>position</b></a>(byte[], long)
  <dd>
 Determines the byte position at which the specified byte
 <code>pattern</code> begins within the <code>BLOB</code>
 value that this <code>Blob</code> object represents.
  <dt> <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
	<a href="#position(java.lang.String, long)"><b>position</b></a>(String, long)
  <dd>
 Determines the character position at which the specified substring
 <code>searchstr</code> appears in the <code>CLOB</code>.
  <dt> <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
	<a href="#position(virtuoso.jdbc.VirtuosoBlob, long)"><b>position</b></a>(VirtuosoBlob, long)
  <dd>
 Determines the byte position in the <code>BLOB</code> value
 designated by this <code>Blob</code> object at which
 <code>pattern</code> begins.
  <dt> <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
	<a href="#position(virtuoso.jdbc.VirtuosoClob, long)"><b>position</b></a>(VirtuosoClob, long)
  <dd>
 Determines the character position at which the specified
 <code>Clob</code> object <code>searchstr</code> appears in this
 <code>Clob</code> object.
  <dt> <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
	<a href="#toString()"><b>toString</b></a>()
  <dd>  Returns th String of the object.
</dl>
<a name="methods"></a>
<h2>
  <img src="images/methods.gif" width=151 height=38 alt="Methods">
</h2>
<a name="getBytes(long, int)"><img src="images/red-ball.gif" width=12 height=12 alt=" o "></a>
<a name="getBytes"><b>getBytes</b></a>
<pre>
 public byte[] getBytes(long pos,
                        int length) throws <a href="virtuoso.jdbc.VirtuosoException.html#_top_">VirtuosoException</a>
</pre>
<dl>
  <dd> Returns as an array of bytes part or all of the <code>BLOB</code>
 value that this <code>Blob</code> object designates.  The byte
 array contains up to <code>length</code> consecutive bytes
 starting at position <code>pos</code>.
<p>
  <dd><dl>
    <dt> <b>Parameters:</b>
    <dd> pos - the ordinal position of the first byte in the
 <code>BLOB</code> value to be extracted; the first byte is at
 position 1
    <dd> length - is the number of consecutive bytes to be copied
    <dt> <b>Returns:</b>
    <dd> a byte array containing up to <code>length</code>
 consecutive bytes from the <code>BLOB</code> value designated
 by this <code>Blob</code> object, starting with the
 byte at position <code>pos</code>.
    <dt> <b>Throws:</b> <a href="virtuoso.jdbc.VirtuosoException.html#_top_">VirtuosoException</a>
    <dd> An internal error occurred.
  </dl></dd>
</dl>
<a name="getSubString(long, int)"><img src="images/red-ball.gif" width=12 height=12 alt=" o "></a>
<a name="getSubString"><b>getSubString</b></a>
<pre>
 public String getSubString(long pos,
                            int length) throws <a href="virtuoso.jdbc.VirtuosoException.html#_top_">VirtuosoException</a>
</pre>
<dl>
  <dd> Returns a copy of the specified substring
 in the <code>CLOB</code> value
 designated by this <code>Clob</code> object.
 The substring begins at position
 <code>pos</code> and has up to <code>length</code> consecutive
 characters.
<p>
  <dd><dl>
    <dt> <b>Parameters:</b>
    <dd> pos - the first character of the substring to be extracted.
 The first character is at position 1.
    <dd> length - the number of consecutive characters to be copied
    <dt> <b>Returns:</b>
    <dd> a <code>String</code> that is the specified substring in
 the <code>CLOB</code> value designated by this <code>Clob</code> object
    <dt> <b>Throws:</b> <a href="virtuoso.jdbc.VirtuosoException.html#_top_">VirtuosoException</a>
    <dd> An internal error occurred.
  </dl></dd>
</dl>
<a name="length()"><img src="images/red-ball.gif" width=12 height=12 alt=" o "></a>
<a name="length"><b>length</b></a>
<pre>
 public long length() throws <a href="virtuoso.jdbc.VirtuosoException.html#_top_">VirtuosoException</a>
</pre>
<dl>
  <dd> Returns the number of bytes in the BLOB value
 designated by this Blob object.
<p>
  <dd><dl>
    <dt> <b>Returns:</b>
    <dd> long The length of the BLOB in bytes.
    <dt> <b>Throws:</b> <a href="virtuoso.jdbc.VirtuosoException.html#_top_">VirtuosoException</a>
    <dd> An internal error occurred.
  </dl></dd>
</dl>
<a name="getBinaryStream()"><img src="images/red-ball.gif" width=12 height=12 alt=" o "></a>
<a name="getBinaryStream"><b>getBinaryStream</b></a>
<pre>
 public InputStream getBinaryStream() throws <a href="virtuoso.jdbc.VirtuosoException.html#_top_">VirtuosoException</a>
</pre>
<dl>
  <dd> Retrieves the <code>BLOB</code> designated by this
 <code>Blob</code> instance as a stream.
<p>
  <dd><dl>
    <dt> <b>Returns:</b>
    <dd> a stream containing the <code>BLOB</code> data
    <dt> <b>Throws:</b> <a href="virtuoso.jdbc.VirtuosoException.html#_top_">VirtuosoException</a>
    <dd> An internal error occurred.
  </dl></dd>
</dl>
<a name="getCharacterStream()"><img src="images/red-ball.gif" width=12 height=12 alt=" o "></a>
<a name="getCharacterStream"><b>getCharacterStream</b></a>
<pre>
 public Reader getCharacterStream() throws <a href="virtuoso.jdbc.VirtuosoException.html#_top_">VirtuosoException</a>
</pre>
<dl>
  <dd> Gets the <code>Clob</code> contents as a Unicode stream.
<p>
  <dd><dl>
    <dt> <b>Returns:</b>
    <dd> a Unicode stream containing the <code>CLOB</code> data
    <dt> <b>Throws:</b> <a href="virtuoso.jdbc.VirtuosoException.html#_top_">VirtuosoException</a>
    <dd> An internal error occurred.
  </dl></dd>
</dl>
<a name="getAsciiStream()"><img src="images/red-ball.gif" width=12 height=12 alt=" o "></a>
<a name="getAsciiStream"><b>getAsciiStream</b></a>
<pre>
 public InputStream getAsciiStream() throws <a href="virtuoso.jdbc.VirtuosoException.html#_top_">VirtuosoException</a>
</pre>
<dl>
  <dd> Gets the <code>CLOB</code> value designated by this <code>Clob</code>
 object as a stream of Ascii bytes.
<p>
  <dd><dl>
    <dt> <b>Returns:</b>
    <dd> an ascii stream containing the <code>CLOB</code> data
    <dt> <b>Throws:</b> <a href="virtuoso.jdbc.VirtuosoException.html#_top_">VirtuosoException</a>
    <dd> An internal error occurred.
  </dl></dd>
</dl>
<a name="position(byte[], long)"><img src="images/red-ball.gif" width=12 height=12 alt=" o "></a>
<a name="position"><b>position</b></a>
<pre>
 public long position(byte pattern[],
                      long start) throws <a href="virtuoso.jdbc.VirtuosoException.html#_top_">VirtuosoException</a>
</pre>
<dl>
  <dd> Determines the byte position at which the specified byte
 <code>pattern</code> begins within the <code>BLOB</code>
 value that this <code>Blob</code> object represents.  The
 search for <code>pattern</code. begins at position
 <code>start</code>.
<p>
  <dd><dl>
    <dt> <b>Parameters:</b>
    <dd> pattern - the byte array for which to search
    <dd> start - the position at which to begin searching; the
 first position is 1
    <dt> <b>Returns:</b>
    <dd> the position at which the pattern appears, else -1.
    <dt> <b>Throws:</b> <a href="virtuoso.jdbc.VirtuosoException.html#_top_">VirtuosoException</a>
    <dd> An internal error occurred.
  </dl></dd>
</dl>
<a name="position(virtuoso.jdbc.VirtuosoBlob, long)"><img src="images/red-ball.gif" width=12 height=12 alt=" o "></a>
<a name="position"><b>position</b></a>
<pre>
 public long position(<a href="#_top_">VirtuosoBlob</a> pattern,
                      long start) throws <a href="virtuoso.jdbc.VirtuosoException.html#_top_">VirtuosoException</a>
</pre>
<dl>
  <dd> Determines the byte position in the <code>BLOB</code> value
 designated by this <code>Blob</code> object at which
 <code>pattern</code> begins.  The search begins at position
 <code>start</code>.
<p>
  <dd><dl>
    <dt> <b>Parameters:</b>
    <dd> pattern - the <code>Blob</code> object designating
 the <code>BLOB</code> value for which to search
    <dd> start - the position in the <code>BLOB</code> value
 at which to begin searching; the first position is 1
    <dt> <b>Returns:</b>
    <dd> the position at which the pattern begins, else -1
    <dt> <b>Throws:</b> <a href="virtuoso.jdbc.VirtuosoException.html#_top_">VirtuosoException</a>
    <dd> An internal error occurred.
  </dl></dd>
</dl>
<a name="position(java.lang.String, long)"><img src="images/red-ball.gif" width=12 height=12 alt=" o "></a>
<a name="position"><b>position</b></a>
<pre>
 public long position(String searchstr,
                      long start) throws <a href="virtuoso.jdbc.VirtuosoException.html#_top_">VirtuosoException</a>
</pre>
<dl>
  <dd> Determines the character position at which the specified substring
 <code>searchstr</code> appears in the <code>CLOB</code>.  The search
 begins at position <code>start</code>.
<p>
  <dd><dl>
    <dt> <b>Parameters:</b>
    <dd> searchstr - the substring for which to search
    <dd> start - the position at which to begin searching; the first position
 is 1
    <dt> <b>Returns:</b>
    <dd> the position at which the substring appears, else -1; the first
 position is 1
    <dt> <b>Throws:</b> <a href="virtuoso.jdbc.VirtuosoException.html#_top_">VirtuosoException</a>
    <dd> An internal error occurred.
  </dl></dd>
</dl>
<a name="position(virtuoso.jdbc.VirtuosoClob, long)"><img src="images/red-ball.gif" width=12 height=12 alt=" o "></a>
<a name="position"><b>position</b></a>
<pre>
 public long position(<a href="virtuoso.jdbc.VirtuosoClob.html#_top_">VirtuosoClob</a> searchstr,
                      long start) throws <a href="virtuoso.jdbc.VirtuosoException.html#_top_">VirtuosoException</a>
</pre>
<dl>
  <dd> Determines the character position at which the specified
 <code>Clob</code> object <code>searchstr</code> appears in this
 <code>Clob</code> object.  The search begins at position
 <code>start</code>.
<p>
  <dd><dl>
    <dt> <b>Parameters:</b>
    <dd> searchstr - the <code>Clob</code> object for which to search
    <dd> start - the position at which to begin searching; the first
 position is 1
    <dt> <b>Returns:</b>
    <dd> the position at which the <code>Clob</code> object appears,
 else -1; the first position is 1
    <dt> <b>Throws:</b> <a href="virtuoso.jdbc.VirtuosoException.html#_top_">VirtuosoException</a>
    <dd> An internal error occurred.
  </dl></dd>
</dl>
<a name="hashCode()"><img src="images/red-ball.gif" width=12 height=12 alt=" o "></a>
<a name="hashCode"><b>hashCode</b></a>
<pre>
 public int hashCode()
</pre>
<dl>
  <dd> Returns a hash code value for the object.
<p>
  <dd><dl>
    <dt> <b>Returns:</b>
    <dd> int	The hash code value.
    <dt> <b>Overrides:</b>
    <dd> <a href="java.lang.Object.html#hashCode()">hashCode</a> in class Object
  </dl></dd>
</dl>
<a name="toString()"><img src="images/red-ball.gif" width=12 height=12 alt=" o "></a>
<a name="toString"><b>toString</b></a>
<pre>
 public String toString()
</pre>
<dl>
  <dd> Returns th String of the object.
<p>
  <dd><dl>
    <dt> <b>Returns:</b>
    <dd> String The string value.
    <dt> <b>Overrides:</b>
    <dd> <a href="java.lang.Object.html#toString()">toString</a> in class Object
  </dl></dd>
</dl>
<hr>
<pre>
<a href="packages.html">All Packages</a>  <a href="tree.html">Class Hierarchy</a>  <a href="Package-virtuoso.jdbc.html">This Package</a>  <a href="virtuoso.jdbc.Types.html#_top_">Previous</a>  <a href="virtuoso.jdbc.VirtuosoCallableStatement.html#_top_">Next</a>  <a href="AllNames.html">Index</a></pre>
</body>
</html>
END_PAGE
    chmod 644 $file
}

ChkExp ()
{
  num=`ls -1R exp | grep html | wc -l`
  if [ "$num" -ne "21" ]
  then
      echo "***FAILED: Export to local file system (files $num)" | tee -a $LOGFILE
  else
      echo "PASSED: Export to local file system (files $num)" | tee -a $LOGFILE
  fi
}

MakeIni ()
{
   MAKECFG_FILE $TESTCFGFILE $PORT $CFGFILE
   case $SERVER in
   *[Mm]2*)
   cat >> $CFGFILE <<END_HTTP
http_port: $TPORT
http_threads: 7
http_keep_alive_timeout: 15
http_max_keep_alives: 10
http_max_cached_proxy_connections: 10
http_proxy_connection_cache_timeout: 15
dav_root: DAV
END_HTTP
   ;;
   *virtuoso*)
   cat >> $CFGFILE <<END_HTTP1
[HTTPServer]
ServerPort = $TPORT
ServerRoot = .
ServerThreads = 7
MaxKeepAlives = 6
KeepAliveTimeout = 15
MaxCachedProxyConnections = 10
ProxyConnectionCacheTimeout = 15
DavRoot 		= DAV
END_HTTP1
;;
esac
}

CHECK_HTTP_PORT()
{
  port=$1
  stat=`netstat -an | grep "[\.\:]$port " | grep LISTEN`
  while [ "z$stat" = "z" ]
  do
    sleep 1
    stat=`netstat -an | grep "[\.\:]$port " | grep LISTEN`
  done
  LOG "PASSED: Virtuoso HTTP/WebDAV Server successfully started on port $port"
}


BANNER "STARTED SERIES OF WEB LOADER TESTS"
NOLITE
LOG "Web Loader test"
#CLEANUP
rm -f $LOGFILE

LOG "Building WEB site"
mkdir exp
mkdir dir1
mkdir dir1/sub11
mkdir dir1/sub12
mkdir dir2
mkdir dir2/sub21
mkdir dir2/sub22
mkdir dir3
mkdir dir3/sub31
mkdir dir3/sub32

GenDefPage
GenErrPage
GenStartPage
GenPage 2 sub11 ./dir1/
GenEndPage 4 ./dir1/sub11/
GenEndPage 5 ./dir1/sub11/

GenPage 3 sub12 ./dir1/
GenEndPage 6 ./dir1/sub12/
GenEndPage 7 ./dir1/sub12/

GenPage 8 sub21 ./dir2/
GenEndPage 10 ./dir2/sub21/
GenEndPage 11 ./dir2/sub21/


GenPage 9 sub22 ./dir2/
GenEndPage 12 ./dir2/sub22/
GenEndPage 13 ./dir2/sub22/


GenPage 14 sub31 ./dir3/
GenEndPage 16 ./dir3/sub31/
GenEndPage 17 ./dir3/sub31/


GenPage 15 sub32 ./dir3/
GenEndPage 18 ./dir3/sub32/
GenEndPage 19 ./dir3/sub32/


STOP_SERVER
MakeIni
START_SERVER $DS1 1000
CHECK_HTTP_PORT $TPORT

if [ "z$HOST_OS" != "z" ]
then
cygwinver=`uname -r | grep '20.1'`
exp_path=`pwd`
if [ "z$cygwinver" = "z" ]
then
  exp_path="`echo "$exp_path" | cut -b11-11`:`echo "$exp_path" | cut -b12-`/exp/"
else
  exp_path="`echo "$exp_path" | cut -b3-3`:`echo "$exp_path" | cut -b4-`/exp/"
fi
else
  exp_path="exp/"
fi

LOG "Checking URI parser"
RUN $ISQL $DS1 ERRORS=STDOUT VERBOSE=OFF BANNER=OFF PROMPT=OFF -u "HOST=$THOST:$TPORT" < $VIRTUOSO_TEST/uri_test.sql
RUN $ISQL $DS1 ERRORS=STDOUT VERBOSE=OFF BANNER=OFF PROMPT=OFF -u "HOST=$THOST:$TPORT" < $VIRTUOSO_TEST/uri_wide_test.sql
#Main
RUN $ISQL $DS1 ERRORS=STDOUT VERBOSE=OFF BANNER=OFF PROMPT=OFF -u "HOST=$THOST:$TPORT" "EXP_PATH=$exp_path" < $VIRTUOSO_TEST/twcopy.sql

# inside twcopy.sql export to local filesystem is turned off now and not done.
# enable the following line if export is enabled.
# ChkExp

RUN $ISQL $DS1 '"EXEC=shutdown;"' ERRORS=STDOUT

CHECK_LOG
BANNER "COMPLETED WebCopy TEST (twcopy.sh)"
