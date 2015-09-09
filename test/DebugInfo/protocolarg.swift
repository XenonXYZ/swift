// RUN: %target-swift-frontend %s -emit-ir -g -o - | FileCheck %s

func markUsed<T>(t: T) {}

// FIXME: Should be DW_TAG_interface_type
// CHECK: !DICompositeType(tag: DW_TAG_structure_type, name: "IGiveOutInts"
// CHECK-SAME:             identifier: [[PT:"[^"]+"]]
protocol IGiveOutInts {
  func callMe() -> Int64
}

class SomeImplementor : IGiveOutInts {
  init() {} 
  func callMe() -> Int64 { return 1 }
}

func printSomeNumbers(var gen: IGiveOutInts) {
  // CHECK: !DILocalVariable(name: "gen", arg: 1
  // CHECK-SAME:             line: [[@LINE-2]]
  // CHECK-SAME:             type: ![[PT]]
  markUsed(gen.callMe())
}

var i1 : IGiveOutInts = SomeImplementor()

printSomeNumbers(i1)

