from pygeckopb import Twist, Vector, Wrench, Quaternion, Transform
from pygeckopb import Imu, ImuInfo, LaserScan, LaserPt, NavSatFix, Image, CameraInfo, BatteryState, Range
from pygeckopb import Odometry, Pose, OccupancyGrid, Path
from pygeckopb import protobufPack, protobufUnpack
import time
import os


def test_packer():
    v = Vector()
    v.x = -0.1
    v.y = 3.44567
    v.z = 1234.567890
    # v.timestamp = time.time()

    s = protobufPack(v)

    vv = protobufUnpack(s, Vector)

    # print("v", v)
    # print("vv", vv)

    assert v == vv, "pack/unpack didn't work"


def test_vector():
    v = Vector()
    v.x = -0.1
    v.y = 3.44567
    v.z = 1234.567890
    # v.timestamp = time.time()
    s = v.SerializeToString()

    vv = Vector()
    vv.ParseFromString(s)
    assert v == vv

    # pv = protobufUnpack(s, Vector)
    # assert v == pv

    with open('msg.pb', 'wb') as fd:
        fd.write(s)

    with open('msg.pb', 'rb') as fd:
        s = fd.read()

    vvv = Vector()
    vvv.ParseFromString(s)
    assert vv == vvv

    os.remove("msg.pb")


def test_imu():
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

    s = imu.SerializeToString()

    imuu = Imu()
    imuu.ParseFromString(s)
    assert imu == imuu
