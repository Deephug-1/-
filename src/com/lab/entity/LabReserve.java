package com.lab.entity;

import java.sql.Timestamp;
import java.util.Date;

/**
 * 预约信息实体
 */
public class LabReserve {
    private Integer reserveId;
    private Integer labId;
    private String labName;
    private Integer studentId;
    private String studentName;
    private String reserveNum;
    private String tel;
    private Date reserveTime;
    private Timestamp createTime;

    public Integer getReserveId() {
        return reserveId;
    }

    public void setReserveId(Integer reserveId) {
        this.reserveId = reserveId;
    }

    public Integer getLabId() {
        return labId;
    }

    public void setLabId(Integer labId) {
        this.labId = labId;
    }

    public Integer getStudentId() {
        return studentId;
    }

    public void setStudentId(Integer studentId) {
        this.studentId = studentId;
    }

    public String getLabName() {
        return labName;
    }

    public void setLabName(String labName) {
        this.labName = labName;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getReserveNum() {
        return reserveNum;
    }

    public void setReserveNum(String reserveNum) {
        this.reserveNum = reserveNum;
    }

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public Date getReserveTime() {
        return reserveTime;
    }

    public void setReserveTime(Date reserveTime) {
        this.reserveTime = reserveTime;
    }

    public Timestamp getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }

    @Override
    public String toString() {
        return "LabReserve{" +
                "reserveId=" + reserveId +
                ", labId=" + labId +
                ", labName='" + labName + '\'' +
                ", studentId=" + studentId +
                ", studentName='" + studentName + '\'' +
                ", reserveNum='" + reserveNum + '\'' +
                ", tel='" + tel + '\'' +
                ", reserveTime=" + reserveTime +
                ", createTime=" + createTime +
                '}';
    }
}
