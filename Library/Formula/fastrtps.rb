class Fastrtps < Formula
  desc "C++ RTPS implementation"
  homepage "https://github.com/eProsima/Fast-RTPS"
  url "https://github.com/eProsima/Fast-RTPS/archive/v1.0.6.tar.gz"
  sha256 "7a792f14e20956215fd572780673052fd94bdc86cf048c5ab8867aa7f367027b"

  head do
    url "https://github.com/eProsima/Fast-RTPS.git"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"fastrtps_test.cpp").write <<-EOS
    #include <fastrtps/Domain.h>

    int main(int n, char** c) {
      eprosima::fastrtps::ParticipantAttributes pa;
      pa.rtps.setName("brewtest");
      if (eprosima::fastrtps::Domain::createParticipant(pa) == nullptr) {
        return 1;
      }
      return 0;
    }
    EOS

    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lfastrtps", "-o", "tester", "fastrtps_test.cpp"
    system "./tester"
  end
end
