# Activate php.ini variant
PHP_INI_VARIANT="${PHP_INI_VARIANT:-production}"
if [ -f "${PHP_INI_DIR}/php.ini-${PHP_INI_VARIANT}" ]; then
  cp ${PHP_INI_DIR}/php.ini-${PHP_INI_VARIANT} ${PHP_INI_DIR}/php.ini
fi

# Set 'sendmail_path' to point to MailHog
if [ -f "${PHP_INI_DIR}/php.ini" ]; then
  sed -i'' 's#^;sendmail_path =#sendmail_path = /usr/sbin/sendmail -S mailhog:1025#g' ${PHP_INI_DIR}/php.ini
fi
