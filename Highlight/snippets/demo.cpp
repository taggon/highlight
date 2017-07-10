/* Copyright 2015 The TensorFlow Authors. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

#include "tensorflow/core/lib/io/format.h"
#include "tensorflow/core/lib/core/coding.h"
#include "tensorflow/core/lib/core/errors.h"
#include "tensorflow/core/lib/hash/crc32c.h"

namespace tensorflow {
namespace table {

void Footer::EncodeTo(string* dst) const {
#ifndef NDEBUG
  const size_t original_size = dst->size();
#endif
  metaindex_handle_.EncodeTo(dst);
  index_handle_.EncodeTo(dst);
  dst->resize(2 * BlockHandle::kMaxEncodedLength);  // Padding
  core::PutFixed32(dst, static_cast<uint32>(kTableMagicNumber & 0xffffffffu));
  core::PutFixed32(dst, static_cast<uint32>(kTableMagicNumber >> 32));
  assert(dst->size() == original_size + kEncodedLength);
}

Status Footer::DecodeFrom(StringPiece* input) {
  const char* magic_ptr = input->data() + kEncodedLength - 8;
  const uint32 magic_lo = core::DecodeFixed32(magic_ptr);
  const uint32 magic_hi = core::DecodeFixed32(magic_ptr + 4);
  const uint64 magic =
      ((static_cast<uint64>(magic_hi) << 32) | (static_cast<uint64>(magic_lo)));
  if (magic != kTableMagicNumber) {
    return errors::DataLoss("not an sstable (bad magic number)");
  }

  Status result = metaindex_handle_.DecodeFrom(input);
  if (result.ok()) {
    result = index_handle_.DecodeFrom(input);
  }
  if (result.ok()) {
    // We skip over any leftover data (just padding for now) in "input"
    const char* end = magic_ptr + 8;
    *input = StringPiece(end, input->data() + input->size() - end);
  }
  return result;
}

}  // namespace table
}  // namespace tensorflow
