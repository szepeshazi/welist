import 'package:equatable/equatable.dart';
import 'package:welist_common/common.dart';

class AccessorProfile extends Equatable {
  final String role;

  final PublicProfile profile;

  final String uid;

  AccessorProfile(this.role, this.profile) : uid = profile.reference.id;

  @override
  List<Object> get props => [role, uid];
}
