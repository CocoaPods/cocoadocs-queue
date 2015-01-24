cocoadocs-queue
===============

Enqueues pods and triggers cocoadocs generation work.

How to use
----------

Call: `/api/v1/pods/:name/enqueue` to enqueue a pod.

What it then does
-----------------

The queue will decide who the next pod will be and call a cocoadocs worker.
If the worker refuses to work, it will try the next worker and so on.