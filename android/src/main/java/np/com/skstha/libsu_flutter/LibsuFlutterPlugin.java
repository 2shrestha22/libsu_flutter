package np.com.skstha.libsu_flutter;

import androidx.annotation.NonNull;

import com.topjohnwu.superuser.Shell;

import java.io.IOException;
import java.util.concurrent.TimeUnit;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

/**
 * LibsuFlutterPlugin
 */
public class LibsuFlutterPlugin implements FlutterPlugin, Pigeon.LibSuApi {

    private Shell _shell = null;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        Pigeon.LibSuApi.setup(flutterPluginBinding.getBinaryMessenger(), this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        Pigeon.LibSuApi.setup(binding.getBinaryMessenger(), null);
    }


    @Override
    public void configure(@NonNull Boolean mountMaster, @NonNull Long timeoutInSeconds,
                          @NonNull Boolean debug, Pigeon.Result<Void> result) {
        if (debug) Shell.enableVerboseLogging = BuildConfig.DEBUG;
        final Shell.Builder builder = Shell.Builder.create().setTimeout(timeoutInSeconds);
        if (mountMaster) builder.setFlags(Shell.FLAG_MOUNT_MASTER);
        // Set settings before the main shell can be created
        Shell.setDefaultBuilder(builder);
        result.success(null);
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
        _shell = Shell.getShell();
        final int shellStatus = _shell.getStatus();
        result.success((long) shellStatus);
    }

    @Override
    public void getShellStatus(Pigeon.Result<Long> result) {
        if (_shell == null) {
            result.success((long) Shell.UNKNOWN);
        } else {
            final int shellStatus = _shell.getStatus();
            result.success((long) shellStatus);
        }


    }

    @Override
    public void isRoot(Pigeon.Result<Boolean> result) {
        result.success(Shell.getShell().isRoot());
    }

    @Override
    public void waitAndClose(@NonNull Long timeoutInSeconds, Pigeon.Result<Boolean> result) {
        try {
            if (_shell == null) {
                result.success(true);
            } else {
                final Boolean res = _shell.waitAndClose(timeoutInSeconds, TimeUnit.SECONDS);
                _shell = null;
                result.success(res);
            }
        } catch (IOException e) {
            result.error(e);
        } catch (InterruptedException e) {
            result.error(e);
        }
    }

    @Override
    public void waitForeverAndClose(Pigeon.Result<Void> result) {
        try {
            if (_shell == null) {
                result.success(null);
            } else {
                _shell.waitAndClose();
                _shell = null;
                result.success(null);
            }
        } catch (IOException e) {
            result.error(e);
        }
    }

    @Override
    public void close(Pigeon.Result<Void> result) {
        if (_shell != null) {
            try {
                _shell.close();
                _shell = null;
                result.success(null);
            } catch (IOException e) {
                result.error(e);
            }
        } else {
            result.success(null);
        }
    }

}
