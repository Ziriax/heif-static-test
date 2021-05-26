#include <iostream>
#include <libheif/heif.h>

void main() {
  std::cout << heif_get_version() << std::endl;
}