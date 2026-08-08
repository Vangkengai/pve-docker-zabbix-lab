#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import urllib.request

ZABBIX_URL = "http://127.0.0.1:8080/api_jsonrpc.php"

def call_zabbix_api(method, params, auth=None):
    """封装 Zabbix JSON-RPC API 调用"""
    headers = {'Content-Type': 'application/json-rpc'}
    payload = {
        "jsonrpc": "2.0",
        "method": method,
        "params": params,
        "id": 1,
        "auth": auth
    }
    req = urllib.request.Request(
        ZABBIX_URL, 
        data=json.dumps(payload).encode('utf-8'), 
        headers=headers
    )
    try:
        with urllib.request.urlopen(req, timeout=5) as response:
            return json.loads(response.read().decode('utf-8'))
    except Exception as e:
        print(f"[Error] API request failed: {e}")
        return None

if __name__ == "__main__":
    print("Initializing Zabbix API Sync Tool...")
    # 测试获取 Zabbix API 版本
    version_info = call_zabbix_api("apiinfo.version", {})
    if version_info and "result" in version_info:
        print(f"[Success] Connected to Zabbix Server. Version: {version_info['result']}")
    else:
        print("[Warning] Could not fetch Zabbix version info.")
