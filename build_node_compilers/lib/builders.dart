// Copyright (c) 2018, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:build/build.dart';
import 'package:build_node_compilers/build_node_compilers.dart';

const ddcKernelExtension = '.ddc.dill';

Builder devCompilerBuilder(_) => const DevCompilerBuilder();
Builder nodeEntrypointBuilder(BuilderOptions options) =>
    new NodeEntrypointBuilder.fromOptions(options);
