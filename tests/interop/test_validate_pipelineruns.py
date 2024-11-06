import logging
import os

import pytest
from validatedpatterns_tests.interop import components

from . import __loggername__

logger = logging.getLogger(__loggername__)

oc = os.environ["HOME"] + "/oc_client/oc"


@pytest.mark.test_validate_pipelineruns
def test_validate_pipelineruns(openshift_dyn_client):
    logger.info("Checking Openshift pipelines")
    project = "quarkuscoffeeshop-cicd"

    expected_pipelines = [
        "build-and-push-quarkuscoffeeshop-barista",
        "build-and-push-quarkuscoffeeshop-counter",
        "build-and-push-quarkuscoffeeshop-customerloyalty",
        "build-and-push-quarkuscoffeeshop-customermocker",
        "build-and-push-quarkuscoffeeshop-inventory",
        "build-and-push-quarkuscoffeeshop-kitchen",
        "build-and-push-quarkuscoffeeshop-web",
    ]

    expected_pipelineruns = [
        "quarkuscoffeeshop-barista",
        "quarkuscoffeeshop-counter",
        "quarkuscoffeeshop-customerloyalty",
        "quarkuscoffeeshop-customermocker",
        "quarkuscoffeeshop-inventory",
        "quarkuscoffeeshop-kitchen",
        "quarkuscoffeeshop-web",
    ]

    err_msg = components.validate_pipelineruns(
        openshift_dyn_client, project, expected_pipelines, expected_pipelineruns
    )
    if err_msg:
        logger.error(f"FAIL: {err_msg}")
        assert False, err_msg
    else:
        logger.info("PASS: Pipeline verification succeeded.")
