#!/bin/bash
set -e

rm -f /psy_assess_api/tmp/pids/server.pid

exec "$@"
