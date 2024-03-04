#!/usr/bin/env python3
import sys
import time
import os
import subprocess
import jinja2
import psycopg2

ODOO_CONF_TEMPLATE = """
[options]
addons_path = {{ env['ADDONS_PATH'] }}
data_dir = /odoo/data
auto_reload = False
db_host = {{ env['DB_HOST'] }}
db_port = {{ env['DB_PORT'] }}
db_name = {{ env['DB_NAME'] }}
db_user = {{ env['DB_USER'] }}
db_password = {{ env['DB_PASSWORD'] }}
list_db = False
without_demo = True
proxy_mode = True
; admin_passwd = admin
; csv_internal_sep = ,
; db_maxconn = 64
; db_name = False
; db_template = template1
; dbfilter = .*
; debug_mode = False
; email_from = False
; limit_memory_hard = 2684354560
; limit_memory_soft = 2147483648
; limit_request = 8192
; limit_time_cpu = 60
; limit_time_real = 120
; list_db = True
; log_db = False
; log_handler = [':INFO']
; log_level = info
; logfile = None
; longpolling_port = 8072
; max_cron_threads = 2
; osv_memory_age_limit = 1.0
; osv_memory_count_limit = False
; smtp_password = False
; smtp_port = 25
; smtp_server = localhost
; smtp_ssl = False
; smtp_user = False
; workers = 0
; xmlrpc = True
; xmlrpc_interface = 
; xmlrpc_port = 8069
; xmlrpcs = True
; xmlrpcs_interface = 
; xmlrpcs_port = 8071
"""
ODOO_RC="/odoo/odoo.conf"
def create_odoo_conf(env):
    conf = jinja2.Template(ODOO_CONF_TEMPLATE).render(env=env)
    with open(ODOO_RC, "w") as f:
        f.write(conf)

def wait_postges(env, timeout=10):
    start_time = time.time()
    while (time.time() - start_time) < timeout:
        try:
            conn = psycopg2.connect(
                user=env['DB_USER'], 
                host=env['DB_HOST'], 
                port=env['DB_PORT'], 
                password=env['DB_PASSWORD'], 
                dbname=env['DB_NAME'])
            error = ''
            break
        except psycopg2.OperationalError as e:
            error = e
        else:
            conn.close()
        time.sleep(1)
    if error:
        print("Database connection failure: %s" % error, file=sys.stderr)
        sys.exit(1)

DEFAULTS = dict(
    DB_USER = 'odoo',
    DB_PASSWORD = 'odoo',
    DB_NAME = 'odoo',
    DB_HOST = 'db',
    DB_PORT = 5432
)

if __name__ == '__main__':
    env = DEFAULTS
    env.update(os.environ)

    if env['ADDONS_PATH']:
        env['ADDONS_PATH'] = ','.join([
            '/odoo/addons',
            '/odoo/addons/server-tools-16.0',
            env['ADDONS_PATH']
        ])
    args = sys.argv[1:]
    print(f"STARTING... \nArgs: {args}\nEnv: {env}")
    if args[0] == "odoo":
        create_odoo_conf(env)
        wait_postges(env)
    if subprocess.call(args) != 0:
        sys.exit(1)
