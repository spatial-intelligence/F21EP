#!/opt/venv/bin/python3

import feedparser
from datetime import datetime

rss_url = "http://feeds.bbci.co.uk/news/rss.xml"

feed = feedparser.parse(rss_url)
top_entry = feed.entries[2] if feed.entries else None
title = top_entry.title if top_entry else "No entries"

with open("cron_rss.log", "a") as f:
    f.write(f"{datetime.now()}: {title}\n")
