import logging
import os
import subprocess

import pytest

from . import __loggername__
from .crd import ArgoCD

logger = logging.getLogger(__loggername__)

oc = os.environ["HOME"] + "/oc_client/oc"

"""
Validate following retail on edge site (line server):

1) applications health (Applications deployed through argocd)
"""


@pytest.mark.test_validate_edge_site_components
def test_validate_edge_site_components():
    logger.info("Checking Openshift version on edge site")
    version_out = subprocess.run([oc, "version"], capture_output=True)
    version_out = version_out.stdout.decode("utf-8")
    logger.info(f"Openshift version:\n{version_out}")


@pytest.mark.validate_argocd_applications_health_edge_site
def test_validate_argocd_applications_health_edge_site(openshift_dyn_client):
    namespace = "oepnshift-gitops"

    argocd_apps_status = dict()
    logger.info("Get all applications deployed by argocd on edge site")

    for app in ArgoCD.get(dyn_client=openshift_dyn_client, namespace=namespace):
        app_name = app.instance.metadata.name
        app_health = app.health
        argocd_apps_status[app_name] = app_health
        logger.info(f"Health status of {app_name} is: {app_health}")

    if False in (argocd_apps_status.values()):
        err_msg = f"Some or all applications deployed on edge site are Degraded/Unhealthy: {argocd_apps_status}"
        logger.error(f"FAIL: {err_msg}")
        assert False, err_msg
    else:
        logger.info("PASS: All applications deployed on edge site are healthy.")
