package com.marklogic.hub.flow;

public interface FlowStatusListener {
    void onStatusChange(long jobId, int percentComplete, String message);
}
