: Version 1.0
: Author Ihor Koliasa
@echo off

: parameters
set DOM=electrical.express
set DOM_KEY=el
set APACHE_VER=Apache_2.4-PHP_8.0-8.1

: create .txt config file
set config_txt=generate-temp-config.txt
(
	echo nsComment = "Do not close the window until the certificate is generated"
	echo basicConstraints = CA:false
	echo subjectKeyIdentifier = hash
	echo authorityKeyIdentifier = keyid,issuer
	echo keyUsage = nonRepudiation, digitalSignature, keyEncipherment
	echo.
	echo subjectAltName = @alt_names
	echo [alt_names]
	echo DNS.1 = %DOM%
	echo DNS.2 = www.%DOM%
) > %config_txt%

mkdir %DOM_KEY%

set OSAPACHE_DIR=%~dp0..\..\..\modules\http\%APACHE_VER%
set OPENSSL_CONF=%OSAPACHE_DIR%\conf\openssl.cnf
"%OSAPACHE_DIR%\bin\openssl" req -x509 -sha256 -newkey rsa:2048 -nodes -days 5475 -keyout %DOM_KEY%\%DOM_KEY%-rootCA.key -out %DOM_KEY%\%DOM_KEY%-rootCA.crt -subj /CN=OSPanel-%DOM_KEY%/
"%OSAPACHE_DIR%\bin\openssl" req -newkey rsa:2048 -nodes -days 5475 -keyout %DOM_KEY%/%DOM_KEY%-server.key -out %DOM_KEY%\%DOM_KEY%-server.csr -subj /CN=%DOM_KEY%/
"%OSAPACHE_DIR%\bin\openssl" x509 -req -sha256 -days 5475 -in %DOM_KEY%\%DOM_KEY%-server.csr -extfile %config_txt% -CA %DOM_KEY%\%DOM_KEY%-rootCA.crt -CAkey %DOM_KEY%\%DOM_KEY%-rootCA.key -CAcreateserial -out %DOM_KEY%\%DOM_KEY%-server.crt
"%OSAPACHE_DIR%\bin\openssl" dhparam -out %DOM_KEY%\%DOM_KEY%-dhparam.pem 2048

del %DOM_KEY%\%DOM_KEY%-server.csr
del %DOM_KEY%\%DOM_KEY%-dhparam.pem
del %DOM_KEY%\%DOM_KEY%-rootCA.srl
del %config_txt%

pause