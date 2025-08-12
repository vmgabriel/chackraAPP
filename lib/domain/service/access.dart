import 'package:shared_preferences/shared_preferences.dart';

// Entity
import 'package:argos_home/domain/entity/access.dart' as access_entity;
import 'package:argos_home/domain/entity/profile.dart' as profile_entity;

// Repositories
import 'package:argos_home/domain/repository/access_repository.dart' as access_repository;
import 'package:argos_home/domain/repository/profile_repository.dart' as profile_repository;
import 'package:argos_home/domain/port/server/login.dart' as login_server;
import 'package:argos_home/domain/port/server/profile.dart' as profile_server;

// Exceptions
import 'package:argos_home/domain/port/server/exceptions.dart' as exception_port;

// Infra
import 'package:argos_home/infra/builder.dart' as infra_builder;


class AccessService {
  infra_builder.InfraBuilder infraBuilder = infra_builder.InfraBuilder.build();

  AccessService({infra_builder.InfraBuilder? infraBuilder});

  Future<access_entity.LoginResponseType> login(String email, String password) async {
    var UOW = infraBuilder.UOW;
    var migrator = infraBuilder.migrator;
    var loginServer = infraBuilder.getServer<login_server.LoginApiHttp>("login");
    var profileServer = infraBuilder.getServer<profile_server.ProfileApiHttp>("profile");
    var accessRepository = infraBuilder.getRepository<access_repository.AccessRepository>("access");
    var profileRepository = infraBuilder.getRepository<profile_repository.ProfileRepository>("profile");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    access_entity.AccessToken response;
    try {
      response = await loginServer.login(email, password);
    } on exception_port.NotValidErrorClient {
      return access_entity.LoginResponseType.DataNotValid;
    } on exception_port.InternalServerErrorClient {
      return access_entity.LoginResponseType.ServerConnection;
    } on exception_port.NotAuthenticatedErrorClient {
      return access_entity.LoginResponseType.DataNotValid;
    } on exception_port.NotAuthorizedErrorClient {
      return access_entity.LoginResponseType.DataNotValid;
    } catch (e) {
      return access_entity.LoginResponseType.ServerConnection;
    }

    var accessByEmailResponse = await accessRepository.getByEmail(email);
    if (accessByEmailResponse == null) {
      UOW.destroy();
      await migrator.migrate();
      await accessRepository.saveAs(email, response);
    } else {
      await accessRepository.update(email, response);
    }

    await prefs.setString('email', email);
    await prefs.setString('token', response.accessToken);
    await prefs.setString('typeToken', response.type);

    await infraBuilder.executeSync("profile");
    var currentProfile = await profileRepository.getByEmail(email);
    print("currentProfile: ${currentProfile!.imageUrl}");

    return access_entity.LoginResponseType.LoginSuccess;
  }

  Future<profile_entity.Profile> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var profileRepository = infraBuilder.getRepository<profile_repository.ProfileRepository>("profile");

    var currentProfile = await profileRepository.getByEmail(prefs.getString("email")!);
    return currentProfile!;
  }

  Future<String> getImageUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var profileRepository = infraBuilder.getRepository<profile_repository.ProfileRepository>("profile");

    String currentImage = "https://picsum.photos/id/237/300/300";
    print("imageUrl 1: ${prefs.getString('imageUrl')}");
    if (prefs.getString("imageUrl") == null) {
      var currentProfile = await profileRepository.getByEmail(prefs.getString("email")!);
      currentImage = (currentProfile!.imageUrl == "") ? currentImage : currentProfile.imageUrl;
      await prefs.setString("imageUrl", currentImage);
    }

    print("imageUrl 2: ${prefs.getString('imageUrl')}");
    return prefs.getString("imageUrl") ?? currentImage;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var key in await prefs.getKeys()) {
      await prefs.remove(key);
    }
    infraBuilder.UOW.destroy();
  }

  Future<access_entity.CreateResponseType> create(profile_entity.User newUser) async {
    var userServer = infraBuilder.getServer<profile_server.UserApiHttp>("user");

    const createdSuccess = access_entity.CreateResponseType.CreatedSuccess;
    try {
      await userServer.create(newUser);
    } on exception_port.NotValidErrorClient {
      return access_entity.CreateResponseType.DataNotValid;
    } on exception_port.InternalServerErrorClient {
      return access_entity.CreateResponseType.ServerConnection;
    } on exception_port.NotAuthenticatedErrorClient {
      return access_entity.CreateResponseType.ServerConnection;
    } on exception_port.NotAuthorizedErrorClient {
      return access_entity.CreateResponseType.ServerConnection;
    } on exception_port.UsernameHasAlreadyBeenTakenErrorClient {
      return access_entity.CreateResponseType.UsernameAlreadyExists;
    } on exception_port.EmailHasAlreadyBeenTakenErrorClient {
      return access_entity.CreateResponseType.EmailAlreadyExists;
    } catch (e) {
      return access_entity.CreateResponseType.ServerConnection;
    }

    return createdSuccess;
  }
}