Resque Concurrency Limiter
===
Tested against Resque 1.23.0.

Only let's one job run at a time, and limits how many of the same job can be queued at a time.

Primarily for things like syncing complex data to a remote API. Where having the same job running twice at the same time can cause issues, but you still want to let multiple jobs be queued to ensure data is synced.