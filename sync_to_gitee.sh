#!/bin/bash

owner="curlly-brackets"
repo="grow-in-juejin"
branch=${1:-master}
# 读取环境变量中的GITEE_ACCESS_TOKEN赋值给access_token
access_token=$GITEE_ACCESS_TOKEN

sync_file() {
    path=$1

    # Get the operating system name
    os=$(uname -s)

    # Set the base64 command line argument based on the operating system
    if [ "$os" == "Darwin" ]; then
        argument="-b 0"
    else
        argument="-w 0"
    fi

    # 读取activity.json的内容，进行base64编码得到encodedContent
    encodedContent=$(cat "${path}" | base64 ${argument})
    
    # 请求https://gitee.com/api/v5/repos/{owner}/{repo}/contents/{path}?access_token={access_token}获取响应数据中的sha值
    response=$(curl -s -X GET "https://gitee.com/api/v5/repos/${owner}/${repo}/contents/${path}?access_token=${access_token}&ref=${branch}")
    sha=$(echo "$response" | jq -r .sha)

    # 将access_token、encodedContent和sha组装成请求体，发送一个PUT请求到https://gitee.com/api/v5/repos/{owner}/{repo}/contents/{path}
    requestBody=$(printf '{"access_token":"%s","content":"%s","message":"update activity.json","sha":"%s"}' "$access_token" "$encodedContent" "$sha")
    curl -s -X PUT -H "Content-Type: application/json" -d "${requestBody}" "https://gitee.com/api/v5/repos/${owner}/${repo}/contents/${path}?&branch=${branch}"

}

sync_file  "activity.json"
sync_file  "pin_activity.json"
sync_file  "other_activity.json"
sync_file  "topics.json"
sync_file  "topics_v2.json"
