import 'package:fpdart/fpdart.dart';
import 'package:realstateclient/core/widgets/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;

typedef FutureVoid = FutureEither<void>;
