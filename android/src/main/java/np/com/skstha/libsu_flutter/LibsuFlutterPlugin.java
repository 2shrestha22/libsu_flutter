package np.com.skstha.libsu_flutter;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

import com.topjohnwu.superuser.Shell;

/**
 * LibsuFlutterPlugin
 */
public class LibsuFlutterPlugin implements FlutterPlugin, Pigeon.LibSuApi {
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        Pigeon.LibSuApi.setup(flutterPluginBinding.getBinaryMessenger(), this);

        Shell.enableVerboseLogging = BuildConfig.DEBUG;
        // Set settings before the main shell can be created
        Shell.setDefaultBuilder(Shell.Builder.create()
                .setFlags(Shell.FLAG_MOUNT_MASTER)
                .setTimeout(10)
        );
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        Pigeon.LibSuApi.setup(binding.getBinaryMessenger(), null);
    }


    @Override
    public void isAppGrantedRoot(Pigeon.Result<Boolean> result) {
        final Boolean res = Shell.isAppGrantedRoot();
        result.success(res);
    }

    @Override
    public void getPlatformVersion(Pigeon.Result<String> result) {
        result.success("Android " + android.os.Build.VERSION.RELEASE);
    }

    @Override
    public void createShell(Pigeon.Result<Long> result) {
        final int shellStatus = Shell.getShell().getStatus();
        result.success((long) shellStatus);
    }


}
