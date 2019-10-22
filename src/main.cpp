#include <iostream>
#include <string>
#include <assert.h>
#include "proto/standard_msgs.pb.h"

using namespace std;

int main(){
    GOOGLE_PROTOBUF_VERIFY_VERSION;
    standard_msgs::Vector v;
    v.set_x(1.0);

    string s;
    v.SerializeToString(&s);

    cout << "size:" << s.size() << endl;

    standard_msgs::Vector vv;
    vv.ParseFromString(s);

    assert(vv.x() == v.x());

    google::protobuf::ShutdownProtobufLibrary();

    return 0;
}
