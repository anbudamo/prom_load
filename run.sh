if [[ "$1" == a ]]; then
	echo "Restarting Avalanche..."
	/users/adamodar/go/bin/avalanche \
  	  --counter-metric-count=5 \
	  --gauge-metric-count=0 \
  	  --series-count=600 \
  	  --value-interval=300 \
  	  --series-interval=0 \
  	  --port=9001 > avalanche_log 2>&1 &
	echo "Printing Avalance --help to avalanche_log"
	/users/adamodar/go/bin/avalanche --help >> avalanche_log 2>&1 &
else
	echo "Starting Prometheus..."
	sudo systemctl start prometheus
	sleep 2 # Wait for Prom to start before starting Avalanche
	echo "Starting Avalanche..."
        /users/adamodar/go/bin/avalanche \
          --counter-metric-count=5 \
          --series-count=600 \
          --label-count=3 \
          --value-interval=300 \
          --series-interval=0 \
          --port=9001 > avalanche_log 2>&1 &
	echo "Printing Avalance --help to avalanche_log"
	/users/adamodar/go/bin/avalanche --help >> avalanche_log 2>&1 &
fi
