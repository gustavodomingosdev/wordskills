#!/bin/bash

# Credenciais de administrador
SPLUNK_USERNAME="admin"
SPLUNK_PASSWORD="Senai@123"

# Iniciar o Splunk
$SPLUNK_HOME/bin/splunk start --accept-license --answer-yes --no-prompt

# Configurar input do syslog

$SPLUNK_HOME/bin/splunk create app MyApp -template sample_app

$SPLUNK_HOME/bin/splunk add monitor /var/log/syslog -index main -sourcetype syslog

# Criar um arquivo de configuração para o dashboard
echo "[source::udp:514]
disabled = false
index = main
sourcetype = syslog" > $SPLUNK_HOME/etc/apps/search/local/inputs.conf

# Reiniciar o Splunk para aplicar as configurações
$SPLUNK_HOME/bin/splunk restart

# Aguardar um tempo para permitir que os dados sejam indexados
sleep 30

# Criar o dashboard
$SPLUNK_HOME/bin/splunk create dashboard Syslog_Dashboard -template base.xml

# Adicionar painéis ao dashboard
$SPLUNK_HOME/bin/splunk add panel Syslog_Dashboard -visualization events -type chart -title "Dispositivo Acessado" -search "sourcetype=syslog" -charting.chart "bar" -charting.axisLabelsX.majorLabelStyle.rotation=0
$SPLUNK_HOME/bin/splunk add panel Syslog_Dashboard -visualization events -type chart -title "Data e Hora" -search "sourcetype=syslog" -charting.chart "timechart" -charting.chartOverlay.series="host"
$SPLUNK_HOME/bin/splunk add panel Syslog_Dashboard -visualization events -type chart -title "Usuário" -search "sourcetype=syslog" -charting.chart "pie" -charting.chartOverlay.mode="none" -charting.chartOverlay.legend.position="right"
$SPLUNK_HOME/bin/splunk add panel Syslog_Dashboard -visualization events -type chart -title "Origem da Autenticação" -search "sourcetype=syslog" -charting.chart "pie" -charting.chartOverlay.mode="none" -charting.chartOverlay.legend.position="right"

# Reiniciar o Splunk novamente
$SPLUNK_HOME/bin/splunk restart

echo "Configuração do Splunk concluída!"
