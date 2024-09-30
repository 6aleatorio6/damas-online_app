export default ({ config }) => ({
  name: 'Damas Paia',
  slug: 'Damas-Paia',
  version: '2.0.0',
  scheme: 'damaspaia',
  orientation: 'portrait',
  icon: './src/assets/icon.png',
  userInterfaceStyle: 'automatic',
  splash: {
    image: './src/assets/splash.png',
    resizeMode: 'cover',
    backgroundColor: '#1E1E1E',
  },
  ios: {
    supportsTablet: true,
    bundleIdentifier: 'com.leonardolf.damaspaia',
  },
  android: {
    adaptiveIcon: {
      foregroundImage: './src/assets/icon.png',
      backgroundColor: '#1E1E1E',
    },
    package: 'com.leonardolf.damaspaia',
  },
  web: {
    favicon: './src/assets/icon.png',
  },
  experiments: {
    typedRoutes: true,
  },
  plugins: [
    'expo-router',
    [
      'react-native-fbsdk-next',
      {
        appID: process.env.FACEBOOK_APP_ID || '123456789',
        clientToken: process.env.FACEBOOK_CLIENT_TOKEN || '123456789',
        displayName: 'Damas Paia',
        scheme: 'damaspaia',
        advertiserIDCollectionEnabled: false,
        autoLogAppEventsEnabled: false,
        isAutoInitEnabled: true,
      },
    ],
  ],
  extra: {
    router: {
      origin: false,
    },
    eas: {
      projectId: 'fffe2c4d-7aae-46cf-95bf-cea2dfa97a40',
    },
  },
});