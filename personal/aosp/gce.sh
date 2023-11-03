#!/bin/bash

PROJECT_ID=""
SERVICE_ACCOUNT_ID=""
SERVICE_ACCOUNT_KEY=""

check_gcloud_installed() {
    if ! type gcloud >/dev/null 2>&1; then
        echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
        curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
        apt-get update
        apt-get install google-cloud-sdk -y
        gcloud init
    fi
}

authenticate_gcloud() {
    local active_account=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")

    if [ -z "$active_account" ]; then
        gcloud auth activate-service-account --key-file="${SERVICE_ACCOUNT_KEY}"
    fi
}

create_compute_instance() {
    gcloud compute instances create aosp --project=${PROJECT_ID} \
        --zone=asia-southeast2-a \
        --machine-type=e2-custom-8-65536 \
        --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
        --maintenance-policy=MIGRATE \
        --provisioning-model=STANDARD \
        --service-account=${SERVICE_ACCOUNT_ID} \
        --scopes=https://www.googleapis.com/auth/cloud-platform \
        --enable-display-device \
        --tags=http-server,https-server,lb-health-check \
        --create-disk=auto-delete=yes,boot=yes,device-name=aosp,image=projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2204-jammy-v20231101,mode=rw,size=250,type=projects/${PROJECT_ID}/zones/asia-southeast2-a/diskTypes/pd-ssd \
        --no-shielded-secure-boot \
        --shielded-vtpm \
        --shielded-integrity-monitoring \
        --labels=goog-ec-src=vm_add-gcloud \
        --reservation-affinity=any

    if [ $? -ne 0 ]; then
        echo "Failed to create the compute instance"
        exit 1
    fi
}

validate_args() {
    for i in "$@"; do
        case $i in
        PROJECT_ID=*)
            PROJECT_ID="${i#*=}"
            shift
            ;;
        SERVICE_ACCOUNT_ID=*)
            SERVICE_ACCOUNT_ID="${i#*=}"
            shift
            ;;
        SERVICE_ACCOUNT_KEY=*)
            SERVICE_ACCOUNT_KEY="${i#*=}"
            shift
            ;;
        *) ;;
        esac
    done

    if [ -z "$PROJECT_ID" ] || [ -z "$SERVICE_ACCOUNT_ID" ] || [ -f "$SERVICE_ACCOUNT_KEY" ]; then
        echo "Error: PROJECT_ID, SERVICE_ACCOUNT_ID and SERVICE_ACCOUNT_KEY need to be specified."
        exit 1
    fi
}

# Main script starts here
validate_args "$@"
check_gcloud_installed
authenticate_gcloud
create_compute_instance