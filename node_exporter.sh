#!/bin/bash

bin_dir="${BIN_DIR:-/usr/local/bin}"

wget "https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz" \
    -O /tmp/node_exporter.tar.gz

mkdir -p /tmp/node_exporter

cd /tmp || { echo "Erreur! Aucun dossier /tmp trouvé.."; exit 1; }

tar xfz /tmp/node_exporter.tar.gz -C /tmp/node_exporter || { echo "ERREUR! Extracting avec tar"; exit 1; }

cp "/tmp/node_exporter/node_exporter-1.3.1.linux-amd64/node_exporter" "$bin_dir"
chown root:staff "$bin_dir/node_exporter"

cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus node exporter
After=local-fs.target network-online.target network.target
Wants=local-fs.target network-online.target network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

systemctl enable node_exporter.service
systemctl start node_exporter.service

echo "YAY! Installation fait!"
