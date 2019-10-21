#!/usr/bin/env python

from proto.vector_pb2 import vector_t
from proto.imu_pb2 import imu_st
import time

if __name__ == "__main__":
    v = vector_t()
    v.x = -0.1
    v.y = 3.44567
    v.z = 1234.567890
    print(v)
    s = v.SerializeToString()
    print("msg[{}]: {}".format(len(s), s))

    with open('msg.pb', 'wb') as fd:
        fd.write(s)

    imu = imu_st()
    imu.accel.x = 1
    imu.accel.y = 11
    imu.accel.z = 111
    imu.gyro.x = 2
    imu.gyro.x = 22.22
    imu.gyro.x = 222.22
    imu.mag.x = 3
    imu.mag.x = 33
    imu.mag.x = 333
    imu.timestamp = time.time()

    print(imu)
    s = imu.SerializeToString()
    print("msg[{}]: {}".format(len(s), s))
