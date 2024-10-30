#!/bin/bash

# s3cmd --configure

ACCESS_KEY=$(cat sa-key.json | jq -r .access_key.key_id | tr -d '"')
SECRET_KEY=$(cat sa-key.json | jq -r .secret | tr -d '"')

# Запись ключей в файл конфигурации s3cmd
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
sed -i "s/^access_key = .*/access_key = $ACCESS_KEY/" "/home/$USER/.s3cfg"
sed -i "s/^secret_key = .*/secret_key = $SECRET_KEY/" /home/$USER/.s3cfg
elif [[ "$OSTYPE" == "darwin"* ]]; then
sed -i '' "s/^access_key = .*/access_key = $ACCESS_KEY/" "/Users/$USER/.s3cfg"
sed -i '' "s/^secret_key = .*/secret_key = $SECRET_KEY/" /Users/$USER/.s3cfg
fi
