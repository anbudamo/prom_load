SERIES_COUNT="$1"

echo "updating and upgrading..."
sudo apt update > update_log
sudo apt upgrade -y > update_log
echo "Installing Prometheus..."
sudo apt install prometheus -y
echo "Installing Grafana..."
sudo apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_11.6.0_amd64.deb
sudo dpkg -i grafana-enterprise_11.6.0_amd64.deb
echo "Getting Go before installing Avalanche..."
wget https://go.dev/dl/go1.22.0.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
source ~/.bashrc
echo "Installing Avalanche..."
go install github.com/prometheus-community/avalanche/cmd/avalanche@latest
echo "Configuring Prometheus..."
sudo sh -c 'cat config > /etc/prometheus/prometheus.yml'
sudo sh -c 'cat rules > /etc/prometheus/recording_rules.yml'
sudo sh -c 'cat default > /etc/default/prometheus'

echo "Starting Prometheus..."
sudo systemctl start prometheus
echo "Starting Grafana
sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
sleep 2 # Wait for Prom to start before starting Avalanche
echo "Starting Avalanche..."
/users/adamodar/go/bin/avalanche \
  --counter-metric-count=200 \
  --series-count="$SERIES_COUNT" \
  --gauge-metric-count=0 \
  --label-count=3 \
  --value-interval=300 \
  --series-interval=0 \
  --port=9001 > avalanche_log 2>&1 &
echo "Printing Avalance --help to avalanche_log"
/users/adamodar/go/bin/avalanche --help >> avalanche_log 2>&1 &
