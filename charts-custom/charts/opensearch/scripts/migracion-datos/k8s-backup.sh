#!/bin/bash

# NAMESPACED EXPORTS
#for ns in $(kubectl get ns --no-headers | cut -d " " -f1); do
ns=efk
  kubectl --namespace="${ns}" get -o=json bindings,cm,ep,ev,limits,pvc,po,podtemplates,rc,quota,secrets,sa,svc,controllerrevisions,ds,deploy,rs,sts,localsubjectaccessreviews,hpa,cj,jobs,leases,ev,ds,deploy,ing,netpol,rs,pods,netpol,pdb,roles,rolebindings | \
    jq '.items[] |
    select(.type!="kubernetes.io/service-account-token") |
    del(
        .spec.clusterIP,
        .metadata.uid,
        .metadata.selfLink,
        .metadata.resourceVersion,
        .metadata.creationTimestamp,
        .metadata.generation,
        .status,
        .spec.template.spec.securityContext,
        .spec.template.spec.dnsPolicy,
        .spec.template.spec.terminationGracePeriodSeconds,
        .spec.template.spec.restartPolicy
    )' >> "./${ns}.json"
#done

# NON-NAMESPACED EXPORTS
kubectl get -o=json cs,ns,no,pv,mutatingwebhookconfigurations,validatingwebhookconfigurations,crds,apiservices,tokenreviews,selfsubjectaccessreviews,selfsubjectrulesreviews,subjectaccessreviews,csr,psp,nodes,psp,clusterrolebindings,clusterroles,pc,sc,volumeattachments | \
    jq '.items[] |
    select(.type!="kubernetes.io/service-account-token") |
    del(
        .spec.clusterIP,
        .metadata.uid,
        .metadata.selfLink,
        .metadata.resourceVersion,
        .metadata.creationTimestamp,
        .metadata.generation,
        .status,
        .spec.template.spec.securityContext,
        .spec.template.spec.dnsPolicy,
        .spec.template.spec.terminationGracePeriodSeconds,
        .spec.template.spec.restartPolicy
    )' >> "./cluster_non-namespaced_export.json"