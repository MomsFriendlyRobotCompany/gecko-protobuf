#!/usr/bin/env python
import numpy as np
from proto.standard_msgs_pb2 import Vector
from proto.sensor_msgs_pb2 import Imu, Image
import time

if __name__ == "__main__":
    v = Vector()
    v.x = -0.1
    v.y = 3.44567
    v.z = 1234.567890
    print(v)
    s = v.SerializeToString()
    print("msg[{}]: {}".format(len(s), s))

    with open('msg.pb', 'wb') as fd:
        fd.write(s)

    imu = Imu()
    imu.linear_acceleration.x = 1
    imu.linear_acceleration.y = 11
    imu.linear_acceleration.z = 111
    imu.angular_velocity.x = 2
    imu.angular_velocity.y = 22.22
    imu.angular_velocity.z = 222.22
    imu.magnetic_field.x = 3
    imu.magnetic_field.y = 33
    imu.magnetic_field.z = 333
    imu.orientation.w = 1
    imu.orientation.x = 0
    imu.orientation.y = 0
    imu.orientation.z = 0
    imu.timestamp = time.time()

    print(imu)
    s = imu.SerializeToString()
    # print("msg[{}]: {}".format(len(s), s))
    print(">> imu size:", len(s))
    imuu = Imu()
    imuu.ParseFromString(s)
    assert imu == imuu, "Imu is different"

    c = Image()
    c.width = 640
    c.height = 480
    c.depth = 1
    c.data = np.random.randint(256, size=(1, 480, 640), dtype=np.uint8).tobytes()
    s = c.SerializeToString()

    print(">> Image size:", len(s))

    cc = Image()
    cc.ParseFromString(s)
    # print(">> Image unpacked:", cc)
    print(">> Image[{}x{}x{}]".format(cc.width,cc.height,cc.depth))
    assert c == cc, "Images are different"
