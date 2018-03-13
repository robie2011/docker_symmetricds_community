# waiting till db is online
x=1
until [ $x = 0 ]
do
    sleep 2
    echo "waiting for mysql db: $IP_DB to be online ..."
    mysql -h$IP_DB -uroot -proot -e "SELECT 0" &> /dev/null
    x=$?
done

first_run_marker=/tmp/first_run.marker
if [ ! -f "$first_run_marker" ]
then
    if [ -z != $DB_SCRIPT_PREINSTALL ]; then
        echo "load db pre-install script: $DB_SCRIPT_PREINSTALL"
        mysql -h$IP_DB -uroot -proot </data/$DB_SCRIPT_PREINSTALL
    fi

    if [ ! "$(ls -A /opt/symmetric-ds/current/engines/)" ]; then
        echo "copy & install engine $SYM_ENGINE_FILE"
        cp /data/$SYM_ENGINE_FILE /opt/symmetric-ds/current/engines/
        engine_name=${SYM_ENGINE_FILE%%.*}
        ls -lah /opt/symmetric-ds/current/engines/
        /opt/symmetric-ds/current/bin/symadmin --no-log-console --engine $engine_name create-sym-tables
    fi

    if [ -z != $DB_SCRIPT_POSTINSTALL ]; then
        echo "load db post-install script: $DB_SCRIPT_POSTINSTALL"
        mysql -h$IP_DB -uroot -proot </data/$DB_SCRIPT_POSTINSTALL
    fi

    /opt/symmetric-ds/current/bin/sym_service install
    touch $first_run_marker
fi

echo "webinterface: http://$(ip addr show eth0 | grep 'inet ' | cut -d: -f2 | awk '{ print $2}'| cut -d/ -f1):31415/"
echo "used enginefile: $SYM_ENGINE_FILE"
/opt/symmetric-ds/current/bin/sym_service start
tail -F /opt/symmetric-ds/current/logs/symmetric*.log

#/opt/symmetric-ds/current/bin/sym