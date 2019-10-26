#include <gtest/gtest.h> // googletest header file
#include <string>
#include <gecko/protobuf/msgs.pb.h>

using namespace std;


TEST(protobuf, vector) {
    Vector v;
    v.set_x(1.0);
    v.set_y(-0.00001);
    v.set_z(1000000.0);

    string s;
    v.SerializeToString(&s);

    Vector vv;
    vv.ParseFromString(s);

    EXPECT_TRUE(v.x() == vv.x());

    // ascii_t tt = a.unpack(s);
    // for (int i=0; i<3; i++)
    //     EXPECT_TRUE(t[i] == tt[i]);
}

// int main(int argc, char** argv){
//     ::testing::InitGoogleTest(&argc, argv);
//     return RUN_ALL_TESTS();
// }
