#include "vector.pb.h"

// using namespace msg;

int main(){
    GOOGLE_PROTOBUF_VERIFY_VERSION;
    msg::Vector v;
    v.set_x(1.0);

    google::protobuf::ShutdownProtobufLibrary();

    return 0;
}
