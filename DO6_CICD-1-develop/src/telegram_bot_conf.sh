#! /bin/bash/

TELEGRAM_BOT_TOKEN=6493062743:AAHbO3fTErW4SwjjkVVOfOQ-e_wlpMvnwiY
TELEGRAM_USER_ID=104090491
TIME="10"
URL="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"
TEXT="$1 $2%0A%0AProject:+$CI_PROJECT_NAME%0AURL:+$CI_PROJECT_URL/pipelines/$CI_PIPELINE_ID/%0ABranch:+$CI_COMMIT_REF_SLUG"

curl -s --max-time $TIME -d "chat_id=$TELEGRAM_USER_ID&disable_web_page_preview=1&text=$TEXT" $URL > /dev/null