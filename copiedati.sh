#!/bin/bash

### CONFIGURAZIONE
SRC="/dati/condivisa/serverdati/public"
NAS_IP="192.168.1.232"
NAS_SHARE="/backup_server"
MOUNTPOINT="/mnt/nas"
DEST="$MOUNTPOINT/backup_serverdati"
LOG="/var/log/backup_public.log"


### LOG INIZIALE
echo "------------------------------" >> $LOG
echo "Inizio backup: $(date)" >> $LOG


### MONTA IL NAS SE NON È GIÀ MONTATO
if ! mountpoint -q $MOUNTPOINT; then
    echo "Montaggio NAS..." >> $LOG
    mount -t nfs -o vers=3 $NAS_IP:$NAS_SHARE $MOUNTPOINT 2>> $LOG
    if [ $? -ne 0 ]; then
        echo "ERRORE: impossibile montare il NAS" >> $LOG
        exit 1
    fi
fi

cd $DEST


### ROTAZIONE SNAPSHOT
for i in {15..1}; do
    if [ -d backup_serverdati.$((i-1)) ]; then
        mv backup_serverdati.$((i-1)) backup_serverdati.$i 2>/dev/null
    fi
done


### CREA NUOVO SNAPSHOT
mkdir -p backup_serverdati.0


### ESECUZIONE RSYNC INCREMENTALE
echo "Esecuzione rsync..." >> $LOG
rsync -av --delete \
    --link-dest=../backup_serverdati.1 \
    "$SRC/" backup_serverdati.0/ \
    >> $LOG 2>&1

if [ $? -ne 0 ]; then
    echo "ERRORE: rsync fallito" >> $LOG
    umount $MOUNTPOINT
    exit 1
fi


### SMONTAGGIO NAS
cd /
umount $MOUNTPOINT 2>> $LOG

echo "Backup completato: $(date)" >> $LOG
echo "------------------------------" >> $LOG



