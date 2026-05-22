echo -e "Inizio Copie su NAS \c" > /var/log/copie.log
date >> /var/log/copie.log
echo -e "Inizio Copie su NAS \c" > /var/log/sincro.log
date >> /var/log/sincro.log
giorno=`date +_%d`
giornoset=`date +%w`
giornolet=`date +%a`

echo -e "Inizio Copie DB ZUCCHETTI \c" >> /var/log/copie.log
date >> /var/log/copie.log

backup_dir=/dati/backup

### Rimuove file vecchi
cd $backup_dir
rm -f *.backup
chmod -R 777 $backup_dir
echo postgres | su postgres -c '/usr/pgsql-14/bin/pg_dump --format=custom -p5432 -f "mipsanseverino-db-$(date +%d-%m-%Y).backup" mipsanseverino' 2>> /var/log/copie.log
 
if [ $? != 0 ]
then
echo -e "Errore Creazione Backup Database Zucchetti \c" >> /var/log/copie.log
date >> /var/log/copie.log
# cat /var/log/copie.log | mutt -s "SANSEVERINO - ERRORE - Esito Copie NAS" copie
cat /var/log/copie.log | mailx -s "SANSEVERINO - ERRORE - Esito Copie NAS NUOVO SERVER" livio@studiosanseverino.it,studiosanseverino@teklabs.it
exit 1
fi

echo -e "Connessione a NAS \c" >> /var/log/copie.log
date >> /var/log/copie.log

if ! mountpoint -q $MOUNTPOINT; then
    mount -t nfs -o vers=3 192.168.1.232:/backup_server /mnt/nas 2>> /var/log/copie.log
fi

if [ $? != 0 ]
then
echo -e "Errore Collegamento NAS \c" >> /var/log/copie.log
date >> /var/log/copie.log
# cat /var/log/copie.log | mutt -s "SANSEVERINO - ERRORE - Esito Copie NAS" copie
cat /var/log/copie.log | mailx -s "SANSEVERINO - ERRORE - Esito Copie NAS NUOVO SERVER" livio@studiosanseverino.it,studiosanseverino@teklabs.it
exit 1
fi
echo -e "Inizio Copia su NAS  \c" >> /var/log/copie.log
date >> /var/log/copie.log
echo -e "Inizio Copia su NAS \c" > /var/log/sincro.log
date >> /var/log/sincro.log
echo -e "Inizio Copia su NAS \c" > /var/log/sincroerror.log
date >> /var/log/sincroerror.log
cd /mnt/nas/backup_servernew
rm -rf backup_server_new.15 2>> /dev/null
mv backup_server_new.14 backup_server_new.15 2>> /dev/null
mv backup_server_new.13 backup_server_new.14 2>> /dev/null
mv backup_server_new.12 backup_server_new.13 2>> /dev/null
mv backup_server_new.11 backup_server_new.12 2>> /dev/null
mv backup_server_new.10 backup_server_new.11 2>> /dev/null
mv backup_server_new.9 backup_server_new.10 2>> /dev/null
mv backup_server_new.8 backup_server_new.9 2>> /dev/null
mv backup_server_new.7 backup_server_new.8 2>> /dev/null
mv backup_server_new.6 backup_server_new.7 2>> /dev/null
mv backup_server_new.5 backup_server_new.6 2>> /dev/null
mv backup_server_new.4 backup_server_new.5 2>> /dev/null
mv backup_server_new.3 backup_server_new.4 2>> /dev/null
mv backup_server_new.2 backup_server_new.3 2>> /dev/null
mv backup_server_new.1 backup_server_new.2 2>> /dev/null
mv backup_server_new.0 backup_server_new.1 2>> /dev/null

rsync -avz --delete --link-dest=../backup_server_new.1 /dati/backup /dati/apache* /dati/DMS /dati/PostgreSQL/14/data/*.conf /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.362.b08-1.el7_9.x86_64/jre /dati/zucchetti /dati/condivisa/servervm /etc/passwd /etc/shadow /etc/samba /etc/hosts /etc/group /etc/rc.d/rc.local backup_server_new.0/ 1>> /var/log/sincro.log 2>> /var/log/sincroerror.log 

if [ $? != 0 ]
then
echo -e "Errore Copia su Disco Esterno NAS" >> /var/log/copie.log
esito=ERRORE
else
echo -e "Copie su Disco Esterno NAS Completate " >> /var/log/copie.log
esito=OK
fi
cd /
umount /mnt/nas 2>> /var/log/copie.log
if [ $? != 0 ]
then
echo -e "Errore Disconnessione Disco Esterno NAS" >> /var/log/copie.log
esito=ERRORE
fi
date >> /var/log/copie.log
#cat /var/log/copie.log | mutt -s "SANSEVERINO - ${esito} - Esito Copie NAS" copie
cat /var/log/copie.log | mailx -s "SANSEVERINO - ${esito} - Esito Copie NAS NUOVO SERVER" livio@studiosanseverino.it,studiosanseverino@teklabs.it
