# Users apps

## Contains

- Contains 2 modules ListUser and AddUser;
- Replaceable DI container;
- API services accross framework Moya;
- Theme;
- UI elements;
- Helpers;
- Extensions;

### Architecture MVVM

- Configurator (Assembly module)
- ViewController
- ViewModel
- Service (recieve data from api)
- Provider (recieve data from local repositories)

### DI container

Current moment [Swinject](https://github.com/Swinject/Swinject) container.
But receive dependencies accross local interface.
For easy swinject replacement with another framework or self-written one.

### UI elements

#### Plug

Plug to display errors.
Configureation via method config with input params and output.

#### ActivityIndicatorView

Indicator of loading content from the server

