# Site Mail Scanner — CrashTech Website Update Requests

## Purpose

Scan Avi's Outlook mailbox for emails requesting updates to the CrashTech 2026 website. For each valid request: make the change, reply to the sender, and log everything.

## Trigger Keywords

Invoke this skill when the user says: "scan mail", "check mail for site updates", "mail scanner", "site update requests", "process site emails", or "run mail scan".

## How It Works

### 1. Read the Tracker

Load the tracking file at:
```
C:\Projects\TechCrash2026\.copilot\site-mail-tracker.json
```

The tracker has this structure:
```json
{
  "last_scanned_utc": "2026-03-15T00:00:00Z",
  "processed": []
}
```

### 2. Scan Outlook for New Emails

Use **Outlook PowerShell COM** to search the Inbox for unread emails received **after** `last_scanned_utc` that contain site-update keywords.

```powershell
$outlook = New-Object -ComObject Outlook.Application
$ns = $outlook.GetNamespace("MAPI")
$inbox = $ns.GetDefaultFolder(6)  # 6 = Inbox
$items = $inbox.Items
$items.Sort("[ReceivedTime]", $true)

# Filter: received after last scan time
$filter = "[ReceivedTime] > '$lastScannedTime'"
$filtered = $items.Restrict($filter)
```

### 3. Identify Update Requests

For each email, check Subject + Body for these keyword patterns (case-insensitive):
- "update the site"
- "update the website"
- "update the web"
- "change on the site"
- "change the website"
- "add to the site"
- "add to the website"
- "modify the site"
- "fix on the site"
- "crashtech site"
- "crashtech website"
- "techcrash site"
- "CrashTech 2026" (thread subject — replies in this thread are likely site requests)
- "VLSI Hackathon" (thread subject — same thread)
- "in the home page"
- "on the home page"
- "please add"
- "please change"
- "please update"
- "please fix"
- "add to the site"
- "add to the website"
- "modify the site"
- "fix on the site"
- "crashtech site"
- "crashtech website"
- "techcrash site"

If a match is found, extract:
- `sender`: email address and display name
- `subject`: email subject
- `received`: timestamp
- `body`: email body text
- `request`: the specific change requested (parse from body)

### 4. Process Each Request

For each identified request:

1. **Evaluate**: Is the request clear and actionable? (e.g., "Add a FAQ section" = clear; "make it better" = unclear)
2. **If clear**: Make the change to the website files in `C:\Projects\TechCrash2026\`
3. **If unclear**: Log it as "needs-clarification" and skip — do NOT reply

### 5. Reply to Sender (Clear Requests Only)

Use Outlook COM to create a reply. **ALWAYS use `$mail.Display()` — NEVER `$mail.Send()`**. Avi reviews and sends manually.

Reply template:
```
Hi [First Name],

This is Avi's AI assistant. Your request has been processed:

Request: [brief summary of what was asked]
Change made: [brief description of what was changed]

The update is live on the site.

Best,
CrashTech AI Assistant (on behalf of Avi Salmon)
```

PowerShell to create reply:
```powershell
$reply = $mailItem.Reply()
$reply.Body = $replyText
$reply.Display()  # NEVER .Send() — Avi reviews first
```

### 6. Update the Tracker

After processing, update `site-mail-tracker.json`:
- Set `last_scanned_utc` to the current UTC time
- Append each processed request to the `processed` array:

```json
{
  "id": "2026-03-15-001",
  "received_utc": "2026-03-15T14:30:00Z",
  "sender": "someone@example.com",
  "sender_name": "John Doe",
  "subject": "Update CrashTech site",
  "request_summary": "Add FAQ section to the home page",
  "status": "completed",
  "change_description": "Added FAQ section with 5 questions to index.html",
  "processed_utc": "2026-03-15T15:00:00Z"
}
```

Status values: `completed`, `needs-clarification`, `skipped`

### 7. Commit and Push

After all changes are made:
```
git add -A
git commit -m "Site update from mail request: [brief summary]"
git push
```

## Tracker File Location

```
C:\Projects\TechCrash2026\.copilot\site-mail-tracker.json
```

This file is gitignored and stays local.

## Safety Rules

1. **NEVER call `$mail.Send()`** — always `$mail.Display()` so Avi reviews before sending
2. **NEVER process unclear requests** — log them and skip
3. **NEVER make destructive changes** (deleting pages, removing content) without confirming with Avi
4. **Always update the tracker** after every scan, even if no requests found
5. **Always commit changes** before replying to confirm the change is saved
6. Review `git diff` before committing to ensure changes are correct

## Execution Flow Summary

```
1. Read tracker → get last_scanned_utc
2. Query Outlook → emails after last_scanned_utc with keywords
3. For each match:
   a. Parse the request
   b. If clear → make the site change → create reply (Display only)
   c. If unclear → log as needs-clarification
   d. Add to tracker
4. Update last_scanned_utc
5. Save tracker
6. Git commit + push site changes
7. Show Avi the reply windows for review
```
