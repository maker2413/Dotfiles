#!/bin/sh

# This script was made by my good buddy Gregory Hendrickson.
# Please check out his GitHub: github.com/ghndrx
kns() {
 echo "Which namespace do you want to set?"
 read -r NAMESPACE

 if [ -n "$NAMESPACE" ]; then
  CURRENT_CONTEXT=$(kubectl config current-context)
  CLUSTER_NAME=$(kubectl config view -o jsonpath="{.contexts[?(@.name==\"$CURRENT_CONTEXT\")].context.cluster}")
  echo "Current cluster: $CLUSTER_NAME"
  kubectl config set-context "$CURRENT_CONTEXT" --namespace="$NAMESPACE"
 else
  echo "No namespace provided."
 fi
}

kns
