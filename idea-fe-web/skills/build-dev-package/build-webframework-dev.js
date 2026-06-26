const path = require('path');
const fs = require('fs-extra');
const { execSync } = require('child_process');

const webFrameworkPath = path.resolve(__dirname, '../../../../../../EAP5/平台/web-framework');
const portalTemplatePath = path.join(webFrameworkPath, 'packages', 'portal-template');
const devZipSource = path.join(portalTemplatePath, 'dev.zip');

function runCommand(command, cwd) {
    console.log(`[INFO] 执行命令: ${command}`);
    execSync(command, { cwd, stdio: 'inherit' });
}

function validateTargetPath(targetPath) {
    if (!fs.existsSync(targetPath)) {
        throw new Error(`目标路径不存在: ${targetPath}`);
    }
    
    const pkgJsonPath = path.join(targetPath, 'package.json');
    if (!fs.existsSync(pkgJsonPath)) {
        console.log(`[WARNING] 目标路径下未找到 package.json，可能不是有效的项目目录`);
    }
    
    return true;
}

async function buildWebFrameworkDev(targetProjectPath) {
    console.log('[INFO] 开始构建 web-framework 开发包...');
    
    try {
        if (!targetProjectPath || targetProjectPath.trim() === '') {
            throw new Error('未提供目标项目路径，请指定要部署开发包的项目位置');
        }
        
        validateTargetPath(targetProjectPath);
        
        const targetPortalTemplatePath = path.join(targetProjectPath, 'node_modules', 'portal-template');
        const targetDevZipPath = path.join(targetPortalTemplatePath, 'dev.zip');
        const targetDevDirPath = path.join(targetPortalTemplatePath, 'dev');
        
        console.log(`[INFO] web-framework 路径: ${webFrameworkPath}`);
        console.log(`[INFO] 目标项目路径: ${targetProjectPath}`);
        console.log(`[INFO] 目标 portal-template 路径: ${targetPortalTemplatePath}`);
        
        console.log('\n[STEP 1/3] 执行 npm run build:portal-dev...');
        runCommand('npm run build:portal-dev', webFrameworkPath);
        
        console.log('\n[STEP 2/3] 验证 dev.zip 是否生成...');
        if (!fs.existsSync(devZipSource)) {
            throw new Error(`dev.zip 未生成，路径: ${devZipSource}`);
        }
        console.log(`[SUCCESS] dev.zip 已生成: ${devZipSource}`);
        
        console.log('\n[STEP 3/3] 部署到目标项目...');
        
        if (!fs.existsSync(targetPortalTemplatePath)) {
            console.log(`[INFO] 创建目录: ${targetPortalTemplatePath}`);
            fs.mkdirsSync(targetPortalTemplatePath);
        }
        
        if (fs.existsSync(targetDevDirPath)) {
            console.log(`[INFO] 删除已存在的 dev 文件夹: ${targetDevDirPath}`);
            fs.removeSync(targetDevDirPath);
        }
        
        console.log(`[INFO] 复制 dev.zip 到目标位置...`);
        fs.copySync(devZipSource, targetDevZipPath);
        
        console.log('\n[SUCCESS] web-framework 开发包构建和部署完成！');
        console.log(`- dev.zip 已部署到: ${targetDevZipPath}`);
        console.log(`- 已删除旧的 dev 文件夹`);
        
        return {
            success: true,
            message: 'web-framework 开发包构建和部署完成',
            devZipPath: targetDevZipPath
        };
        
    } catch (error) {
        console.error(`[ERROR] 构建失败: ${error.message}`);
        throw error;
    }
}

if (require.main === module) {
    const targetPath = process.argv[2];
    
    if (!targetPath) {
        console.error('请提供目标项目路径作为参数');
        console.error('用法: node build-webframework-dev.js <目标项目路径>');
        process.exit(1);
    }
    
    buildWebFrameworkDev(targetPath)
        .then(() => process.exit(0))
        .catch(() => process.exit(1));
}

module.exports = buildWebFrameworkDev;