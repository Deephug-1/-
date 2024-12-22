package com.lab.entity;

import java.sql.Timestamp;
import java.util.Date;

/**
 * 实验室实体
 */
public class Lab {
    private Integer labId;
    private String labName;
    private Integer enableReserveNum;
    private Integer reservedNum;
    private String labDescription;

    public Integer getLabId() {
        return labId;
    }

    public void setLabId(Integer labId) {
        this.labId = labId;
    }

    public String getLabName() {
        return labName;
    }

    public void setLabName(String labName) {
        this.labName = labName;
    }

    public Integer getEnableReserveNum() {
        return enableReserveNum;
    }

    public void setEnableReserveNum(Integer enableReserveNum) {
        this.enableReserveNum = enableReserveNum;
    }

    public Integer getReservedNum() {
        return reservedNum;
    }

    public void setReservedNum(Integer reservedNum) {
        this.reservedNum = reservedNum;
    }

    public String getLabDescription() {
        return labDescription;
    }

    public void setLabDescription(String labDescription) {
        this.labDescription = labDescription;
    }

    @Override
    public String toString() {
        return "Lab{" +
                "labId=" + labId +
                ", labName='" + labName + '\'' +
                ", enableReserveNum=" + enableReserveNum +
                ", reservedNum=" + reservedNum +
                ", labDescription='" + labDescription + '\'' +
                '}';
    }
}
