import type {TurboModule} from 'react-native';
import {TurboModuleRegistry} from 'react-native';

// This is ios only
export interface Spec extends TurboModule {
    isJailbroken(): Promise<boolean>;
}

export default TurboModuleRegistry.get<Spec>('JailbreakDetector');
