if [[ "$1" == a ]]; then
	echo "stopping Avalanche..."
	sudo pkill avalanche
else
	echo "stopping Avalanche..."
        sudo pkill avalanche
	echo "stopping Prometheus..."
	sudo systemctl stop prometheus
	sudo systemctl enable prometheus
fi
